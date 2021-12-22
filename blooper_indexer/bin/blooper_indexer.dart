import 'dart:io';

import 'indexer.dart';

void main(List<String> arguments) async {
  String dbPath = './hive_database';
  // File file = File(dbPath);
  // if (!file.existsSync()) {
  //   file.createSync();
  // }
  Indexer indexer = Indexer(dbPath);
  // indexer.index(1, 'سلام یا سلامتی و تندرستی', 't');
  print(await indexer.getWordIndex('سلام'));
}
