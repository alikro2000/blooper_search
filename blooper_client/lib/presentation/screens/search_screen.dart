import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: const [
            //Header and Search bar

            //Results text view
            Text(
              'Found 2500 results in 3 seconds for the query: Hello World!',
              style: TextStyle(
                fontFamily: 'Segoe_UI',
                fontSize: 18,
              ),
            ),

            //Result Cards

            //Pagination
          ],
        ),
      ),
    );
  }
}
