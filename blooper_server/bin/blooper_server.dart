import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';

import 'database.dart';

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
  String query = httpRequest.uri.queryParameters['query'].toString();
  var timer = Stopwatch();
  timer.start();
  var postingList =
      await CustomDatabaseManager.instance.fetchPostingList(query);
  timer.stop();
  return {
    'query': query,
    'duration': timer.elapsed,
    'postingList': postingList,
  }.toString();
}

void startClient() async {
  final client = HttpClient();
  client.getUrl(Uri.http('localhost:3000', '/', {'query': 'تهران'})).then(
    (httpClientRequest) {
      print('[Client]: Connection established!');
      httpClientRequest.close().then(
        (httpClientResponse) async {
          print(
              '[Client]: Response received from server with code ${httpClientResponse.statusCode}');
          print('[Client]: Response from server is: ' +
              (await httpClientResponse.transform(utf8.decoder).join()));
        },
      );
    },
  );
}
