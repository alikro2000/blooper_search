import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart' as crypto;

class Indexer {
  late int _wordsCount;

  Indexer(String dataBasePath) {
    _wordsCount = 0;
    Hive.init(dataBasePath);
  }

  int getWordsCount() => _wordsCount;

  Future<void> index(int docID, String content, String type) async {
    List<String> processedWords = [];
    for (String word in content.split(' ').map((e) => e.trim())) {
      if (processedWords.contains(word)) {
        continue;
      }
      String wordHash = crypto.md5.convert(utf8.encode(word)).toString();
      var box = await Hive.openBox(wordHash);
      await box.put(docID, {
        'freq': countFrequency(content, word),
        'type': type,
      });
      await box.close();
      ++_wordsCount;
      processedWords.add(word);
      await (await Hive.openBox('processedWords')).put(
        wordHash = crypto.md5.convert(utf8.encode(word)).toString(),
        word,
      );
    }
  }

  Future<List> getWordIndex(String word) async {
    List result = [];
    String wordHash = crypto.md5.convert(utf8.encode(word)).toString();
    var box = await Hive.openBox(wordHash);
    for (int docID in box.keys) {
      var row = box.get(docID);
      result.add({
        'docID': docID,
        'freq': row['freq'],
        'type': row['type'],
      });
    }
    return result;
  }

  int countFrequency(String haystack, String needle) {
    int count = 0;
    int i = -1;
    while ((i = haystack.indexOf(needle, i + 1)) > 0) {
      ++count;
    }
    return count;
  }
}
