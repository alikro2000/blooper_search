import 'dart:collection';

import 'package:hive/hive.dart';

class PageRepositoryManager {
  late HashMap _pageRepo;
  static late PageRepositoryManager instance;

  PageRepositoryManager._internal();

  static init(String pageRepoPath) async {
    instance = PageRepositoryManager._internal();
    instance._pageRepo = HashMap();

    Hive.init(pageRepoPath);
    var box = await Hive.openBox('page_repo');
    for (int docID in box.keys) {
      instance._pageRepo.putIfAbsent(docID, () {
        var row = box.get(docID);
        return {
          'url': row['url'],
          'htmlContent': row['htmlContent'],
          'title': row['title'],
          'snippet': row['snippet'],
        };
      });
    }
    Hive.close();
  }

  Map<String, dynamic> getPageInfo(int docID) {
    return _pageRepo[docID];
  }
}
