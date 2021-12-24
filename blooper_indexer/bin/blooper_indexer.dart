import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:xml/xml.dart';

import 'document_processor.dart';
import 'html_document.dart';
import 'indexer.dart';

void main(List<String> arguments) async {
  String dbPath = './hive_database_2';
  String pageRepositoryPath = './page_repo';
  String datasetPath = './dataset';
  var indexer = Indexer(dbPath);

  // List<HtmlDocument> htmlDocuments = await startIndexing(indexer, datasetPath);

  //Test indexed words
  // saveWordsListAsJson();

  // Test reading data from database
  // print(await testTermFetching('تهران', indexer));
  // await testTermFetching('تهران', indexer);
  // await testTermFetching('دانشگاه', indexer);
  // await testTermFetching('ابوریحان', indexer);
  // await testTermFetching('پردیس', indexer);
  // await testTermFetching('و', indexer);
  await testTermListFetching([
    // '000fbfc8285683ec0251fe4af0a0421a',
    // 'تهران',
    // 'دانشگاه',
    // 'ابوریحان',
    // 'پردیس',
    'و',
    // 'یا',
  ], indexer);

  //Save pages into pages_repository
  // generatePageRepository(pageRepositoryPath, htmlDocuments);
}

Future<List<HtmlDocument>> startIndexing(
  Indexer indexer,
  String datasetPath,
) async {
  var docParser = DocumentProcessor(indexer);
  List<HtmlDocument> htmlDocuments = [];

  Stopwatch totalIndexingTimer = Stopwatch();
  totalIndexingTimer.start();

  for (var xmlFile in await Directory(datasetPath).list().toList()) {
    htmlDocuments.addAll(await processXML(
      xmlFile,
      docParser,
      indexer,
      totalIndexingTimer,
    ));
  }

  await indexer.saveIndexAsHive();
  indexer.reset();

  // List<Future> xmlProcessFutures = [];
  // await Future.wait(xmlProcessFutures);

  totalIndexingTimer.stop();
  print('''[Finished indexing all files in ${totalIndexingTimer.elapsed}]:
  \tHtml Pages count: ${htmlDocuments.length}
  \tIndexed words count: ${indexer.getTotalWordsCount()}
  ''');

  return htmlDocuments;
}

Future<List<HtmlDocument>> processXML(
  FileSystemEntity xmlFile,
  DocumentProcessor docParser,
  Indexer indexer,
  Stopwatch totalIndexingTimer,
) async {
  print(
      '[Started XML Processing @ ${totalIndexingTimer.elapsed}]: ${xmlFile.path}');

  List<HtmlDocument> htmlDocuments = [];
  Stopwatch xmlFileStopWatch = Stopwatch();
  xmlFileStopWatch.start();
  final docsInXml = XmlDocument.parse(File(xmlFile.path).readAsStringSync())
      .findAllElements('DOC');

  for (var doc in docsInXml) {
    htmlDocuments.add(HtmlDocument(
      docID: int.parse(doc.getElement('DOCID')!.text.toString()),
      url: doc.getElement('URL')!.text.toString(),
      htmlContent: doc.getElement('HTML')!.text.toString(),
    ));

    await docParser.processDoc(htmlDocuments.last);

    if (indexer.getWordsCount() >= 150000) {
      print('[Saving into Hive]');
      await indexer.saveIndexAsHive();
      indexer.reset();
    }

    if (htmlDocuments.length % 1000 == 0) {
      print('''
        [Doc Finished at ${totalIndexingTimer!.elapsed}]:
        \t${htmlDocuments.length}-th html doc
        \t${indexer.getTotalWordsCount()} words indexed
        ''');
    }
  }

  xmlFileStopWatch.stop();
  print(
      '[Finished XML Processing in ${xmlFileStopWatch.elapsed} ms]: ${xmlFile.path}');

  return htmlDocuments;
}

Future<void> generatePageRepository(
  String pageRepositoryPath,
  List<HtmlDocument> htmlDocuments,
) async {
  print('[Generating page repository]');
  Hive.close();
  Stopwatch timer = Stopwatch();
  timer.start();
  Hive.init(pageRepositoryPath);
  var box = await Hive.openBox('page_repo');
  for (var htDoc in htmlDocuments) {
    await box.put(htDoc.docID, {
      'url': htDoc.url,
      'htmlContent': htDoc.htmlContent,
      'snippet': DocumentProcessor.getSnippet(htDoc),
    });
  }
  timer.stop();
  print('[Page repository generation finishied in ${timer.elapsed}]');
}

void saveWordsListAsJson() async {
  List<String> words = [];
  var box = await Hive.openBox('processedWords');
  box.keys.forEach((wordHash) {
    words.add(box.get(wordHash));
  });
  File jsonFile = File('pWords.json');
  jsonFile.createSync();
  jsonFile.writeAsStringSync(jsonEncode(words));
}

Future<List> testTermFetching(String term, Indexer indexer) async {
  Stopwatch timer = Stopwatch();
  timer.start();
  var result = await indexer.getWordIndex(term, maxFileIndice: 41);
  timer.stop();
  print('[Fetched results for $term]: ${timer.elapsed}');
  return result.toList();
}

Future<void> testTermListFetching(List<String> terms, Indexer indexer) async {
  List<Box> boxList = [];
  print('[Loading Hives]');
  for (int i = 0; i <= 41; ++i) {
    boxList.add(await Hive.openBox('hive_db_$i'));
    // print(boxList.last.keys);
    // exit(0);
  }
  print('[Hives Loaded]');
  for (String term in terms) {
    Stopwatch timer = Stopwatch();
    timer.start();
    List termResult = [];
    String termHash = Indexer.getWordHash(term);
    print(termHash);
    for (var box in boxList) {
      var items = await box.get(termHash);
      termResult.addAll(items == null ? [] : items as List);
    }
    timer.stop();
    print('[Fetched results for $term]: ${timer.elapsed}');
    // print(termResult);
  }
}
