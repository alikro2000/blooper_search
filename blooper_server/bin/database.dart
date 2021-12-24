import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart' as crypto;

class CustomDatabaseManager {
  static late CustomDatabaseManager instance;
  late List<Box> _hiveBoxes;

  factory CustomDatabaseManager() => instance;

  CustomDatabaseManager._internal();

  static Future<void> init(String dbPath, int hivesCount) async {
    instance = CustomDatabaseManager._internal();
    Hive.init(dbPath);
    instance._hiveBoxes = [];
    for (int i = 0; i <= hivesCount; ++i) {
      instance._hiveBoxes.add(await Hive.openBox('hive_db_$i'));
    }
  }

  Future<List> fetchPostingList (String query) async {
    List result = [];
    for (var box in _hiveBoxes) {
      var items = box.get(getWordHash(query));
      result.addAll(items == null ? [] : items as List);
    }
    return result;
  }

  String getWordHash(String word) {
    return crypto.md5.convert(utf8.encode(word)).toString();
  }
}