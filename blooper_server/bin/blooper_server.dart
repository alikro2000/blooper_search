import 'dart:convert';
import 'dart:io';

import 'database.dart';
import 'page_repository_manager.dart';
import 'utils.dart';

void main(List<String> arguments) async {
  await prepareResources();
  startServer();
}

Future<void> prepareResources() async {
  print('[Loading Page Repository]');
  var timer = Stopwatch();
  timer.start();
  await PageRepositoryManager.init('page_repo');
  timer.stop();
  print('[Finished Loading Page Repository]: ${timer.elapsed}');

  print('[Loading Database]');
  timer.reset();
  timer.start();
  await CustomDatabaseManager.init('hive_database', 41);
  timer.stop();
  print('[Finished Loading Database]: ${timer.elapsed}');
}

void startServer() {
  HttpServer.bind('localhost', 3000).then((server) {
    server.sessionTimeout = 10;
    print(
        '[Server socket started & Listening]: host=${server.address.host},port=${server.port}');
    server.listen((HttpRequest httpRequest) async {
      var result = await processRequest(httpRequest);
      httpRequest.response.headers.contentType = ContentType.json;
      httpRequest.response.headers.add('Access-Control-Allow-Origin', '*');
      httpRequest.response.write(result);
      httpRequest.response.close();
    });
  });
}

Future<String> processRequest(HttpRequest httpRequest) async {
  var timer = Stopwatch();
  timer.start();

  var query = httpRequest.uri.queryParameters['query'].toString();
  var terms = query.split(' ');
  // print(terms);

  var result = await processQuery(terms);

  timer.stop();
  return JsonEncoder().convert({
    'query': query,
    'count': result.length,
    'duration': timer.elapsed.toString(),
    'postingList': result,
  });
}

Future<List> processQuery(List terms) async {
  var termsPostingList = [];
  var result =
      await CustomDatabaseManager.instance.fetchPostingList(terms.first);
  termsPostingList.add(result);
  result = result.map((e) => e['docID']).toList();
  for (int i = 1; i < terms.length; ++i) {
    // if in operators?
    if (terms[i] == 'AND') {
      // print('DOING AND');
      ++i;
      termsPostingList.add(null);
      var second =
          await CustomDatabaseManager.instance.fetchPostingList(terms[i]);
      termsPostingList.add(second);
      result = Utils.andOf(result, second.map((e) => e['docID']).toList());
    } else if (terms[i] == 'OR') {
      // print('DOING OR');
      ++i;
      termsPostingList.add(null);
      var second =
          await CustomDatabaseManager.instance.fetchPostingList(terms[i]);
      termsPostingList.add(second);
      result = Utils.orOf(result, second.map((e) => e['docID']).toList());
    } else if (terms[i] == 'NOT') {
      // print('DOING NOT');
      ++i;
      termsPostingList.add(null);
      var second =
          await CustomDatabaseManager.instance.fetchPostingList(terms[i]);
      termsPostingList.add(second);
      result = Utils.notOf(result, second.map((e) => e['docID']).toList());
    } else {
      // if not in operators
      // print('DOING ELSE');
      // print(terms[i]);
      var second =
          await CustomDatabaseManager.instance.fetchPostingList(terms[i]);
      termsPostingList.add(second);
      result = Utils.andOf(result, second.map((e) => e['docID']).toList());
    }
  }
  //Rank
  var docScores = {};
  for (int docID in result) {
    for (var postingList in termsPostingList) {
      if (postingList == null) {
        continue;
      }
      int score = 0;
      var stream = (postingList as List)
          .where((element) => element['docID'] == docID)
          .map((e) => calculateScore(e));
      if (stream.isNotEmpty) {
        score = stream.reduce((a, b) => a + b);
      }
      docScores.update(docID, (value) => value + score, ifAbsent: () => score);
    }
  }
  result.sort((a, b) => (docScores[b] as int).compareTo(docScores[a] as int));
  
  //Map to pages
  List page_results = [];
  for (int docID in result) {
    page_results.add(PageRepositoryManager.instance.getPageInfo(docID));
  }

  List final_result = [];
  for (int i = 0; i < result.length; ++i) {
    int docID = result[i];
    final_result.add({
      'docID': docID,
      'score': docScores[docID],
      'url': page_results[i]['url'],
      'title': page_results[i]['title'],
      'snippet': page_results[i]['snippet'],
      // 'htmlContent': page_results[i]['htmlContent'],
    });
  }

  return final_result;
}

int calculateScore(Map postingListItem) {
  return (postingListItem['type'] == 't' ? 5 : 1) *
      (postingListItem['freq'] as int);
}

void startClient() async {
  final client = HttpClient();
  client.getUrl(Uri.http('localhost:3000', '/', {'query': '??????????'})).then(
    (httpClientRequest) {
      print('[Client]: Connection established!');
      httpClientRequest.close().then(
        (httpClientResponse) async {
          print(
              '[Client]: Response received from server with code ${httpClientResponse.statusCode}');
        },
      );
    },
  );
}
