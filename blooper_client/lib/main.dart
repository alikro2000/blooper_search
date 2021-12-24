import 'package:blooper_client/data/remote/remote_query_repository.dart';
import 'package:blooper_client/data/repository/query_repository_impl.dart';
import 'package:blooper_client/domain/repository/query_repository.dart';
import 'package:blooper_client/domain/usecase/get_query_result.dart';
import 'package:flutter/material.dart';

void main() async {
  RemoteQueryRepository remoteQueryRepository = RemoteQueryRepositoryImpl();
  QueryRepository queryRepository = QueryRepositoryImpl(remoteQueryRepository);
  (await GetQueryResult(queryRepository)
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
