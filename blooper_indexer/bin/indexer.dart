import 'dart:collection';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart' as crypto;

class Indexer {
  late int _totalWordsCount;
  late int _wordsCount;
  late HashMap _index;
  late int _lastHiveIndex;

  Indexer(String dataBasePath) {
    _totalWordsCount = 0;
    _wordsCount = 0;
    _index = HashMap();
    _lastHiveIndex = 0;
    Hive.init(dataBasePath);
  }

  int getWordsCount() => _wordsCount;

  int getTotalWordsCount() => _totalWordsCount;

  static String getWordHash(String word) =>
      crypto.md5.convert(utf8.encode(word)).toString();

  HashMap getIndex() => _index;

  Future<void> index(int docID, String content, String type) async {
    List<String> processedWords = [];
    for (String word in content.split(' ').map((e) => e.trim())) {
      if (word == '' || word.isEmpty) {
        continue;
      }
      if (processedWords.contains(word)) {
        continue;
      }
      var record = {
        'docID': docID,
        'freq': countFrequency(content, word),
        'type': type,
      };
      var res = _index.update(
        word,
        (value) {
          var current = value as List;
          current.add(record);
          return current;
        },
        ifAbsent: () => [record],
      );
      ++_wordsCount;
      ++_totalWordsCount;
      processedWords.add(word);
      await (await Hive.openBox('processedWords')).put(
        getWordHash(word),
        word,
      );
    }
  }

  void reset() {
    _index.clear();
    _wordsCount = 0;
  }

  Future<void> saveIndexAsHive() async {
    var box = await Hive.openBox('hive_db_$_lastHiveIndex');
    for (var word in _index.keys) {
      await box.put(getWordHash(word), _index[word]);
    }
    await box.close();
    ++_lastHiveIndex;
  }

  Future<List> getWordIndex(String word, {int? maxFileIndice}) async {
    maxFileIndice ??= _lastHiveIndex;
    List postingList = [];
    for (int i = 0; i <= maxFileIndice; ++i) {
      var box = await Hive.openBox('hive_db_$i');
      var items = box.get(getWordHash(word));
      postingList.addAll(items == null ? [] : items as List);
      await box.close();
    }
    // await Hive.close();
    return postingList;
  }

  static int countFrequency(String haystack, String needle) {
    int count = 0;
    int i = -1;
    while ((i = haystack.indexOf(needle, i + 1)) > 0) {
      ++count;
    }
    return count;
  }
}
