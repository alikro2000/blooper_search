import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';

import 'database.dart';
import 'utils.dart';

void main(List<String> arguments) async {
  await prepareResources();
  startServer();

  Future.delayed(Duration(seconds: 2), () {
    startClient();
  });
}

Future<void> prepareResources() async {
  print('[Loading Database]');
  var timer = Stopwatch();
  timer.start();
  await CustomDatabaseManager.init('hive_database', 41);
  timer.stop();
  print('[Finished Loading Database]: ${timer.elapsed}');
}

void startServer() {
  HttpServer.bind('localhost', 3000).then((server) {
    server.sessionTimeout = 10;
    print('Server socket started & Listening!');
    server.listen((HttpRequest httpRequest) async {
      var result = await processRequest(httpRequest);
      httpRequest.response.headers.contentType = ContentType.json;
      httpRequest.response.headers.add('Access-Control-Allow-Origin', '*');
      // httpRequest.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, DELETE, OPTIONS');
      // httpRequest.response.headers.add( 'Access-Control-Allow-Headers', 'Origin, Content-Type');
      // print(httpRequest.response.headers);
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
  print(terms);

  var result = await processQuery(terms);

  // var termsPostingLists = []; //List<Map>
  // The first term is always a word
  // var result = await CustomDatabaseManager.instance.fetchPostingList(terms[0]);
  // termsPostingLists.addAll(result);

  // if (terms.length > 1) {
  //   var right = await CustomDatabaseManager.instance.fetchPostingList(terms[1]);
  //   termsPostingLists.addAll(right);
  //   result = Utils.notOf(result, right);
  // }
  // if (terms.length > 1) {
  //   var res2 = await CustomDatabaseManager.instance.fetchPostingList(terms[1]);
  // }
  // var result = await processQuery(firstTermResult, terms.sublist(1) ?? []);

  //TODO: Rank

  timer.stop();
  return jsonEncode({
    'query': query,
    'count': result.length,
    'duration': timer.elapsed,
    'postingList': result,
  }.toString());
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
      print('DOING AND');
      ++i;
      termsPostingList.add(null);
      var second =
          await CustomDatabaseManager.instance.fetchPostingList(terms[i]);
      termsPostingList.add(second);
      result = Utils.andOf(result, second.map((e) => e['docID']).toList());
    } else if (terms[i] == 'OR') {
      print('DOING OR');
      ++i;
      termsPostingList.add(null);
      var second =
          await CustomDatabaseManager.instance.fetchPostingList(terms[i]);
      termsPostingList.add(second);
      result = Utils.orOf(result, second.map((e) => e['docID']).toList());
    } else if (terms[i] == 'NOT') {
      print('DOING NOT');
      ++i;
      termsPostingList.add(null);
      var second =
          await CustomDatabaseManager.instance.fetchPostingList(terms[i]);
      termsPostingList.add(second);
      result = Utils.notOf(result, second.map((e) => e['docID']).toList());
    } else {
      // if not in operators
      print('DOING ELSE');
      print(terms[i]);
      var second =
          await CustomDatabaseManager.instance.fetchPostingList(terms[i]);
      termsPostingList.add(second);
      result = Utils.andOf(result, second.map((e) => e['docID']).toList());
    }
  }
  return result;
}

void startClient() async {
  final client = HttpClient();
  String query = 'دانشگاه تهران';
  client.getUrl(Uri.http('localhost:3000', '/', {'query': 'تهران'})).then(
    (httpClientRequest) {
      print('[Client]: Connection established!');
      httpClientRequest.close().then(
        (httpClientResponse) async {
          print(
              '[Client]: Response received from server with code ${httpClientResponse.statusCode}');
          // print('[Client]: Response from server is: ' +
          //     (await httpClientResponse.transform(utf8.decoder).join()));
        },
      );
    },
  );
}
