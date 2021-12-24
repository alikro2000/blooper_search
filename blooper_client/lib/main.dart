import 'package:blooper_client/core/get_it.dart';
import 'package:blooper_client/presentation/screens/search_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  GetItInitializer.initGetIt();

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
      home: const SearchScreen(),
    );
  }
}
