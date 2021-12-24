import 'package:blooper_client/core/get_it.dart';
import 'package:blooper_client/domain/repository/query_repository.dart';
import 'package:blooper_client/domain/usecase/get_query_result.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() async {
  GetItInitializer.initGetIt();
  (await GetIt.instance<GetQueryResult>()
          .call('دانشگاه NOT تهران NOT یزد NOT یا NOT و'))
      .fold(
    (l) => print(l),
    (r) => print(r.query),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blooper Client',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Text('Testing... Check your console for info.'),
        ),
      ),
    );
  }
}
