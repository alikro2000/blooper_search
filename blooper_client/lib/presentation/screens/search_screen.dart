import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Header and Search bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Row(
                children: [
                  //GitHub clickable logo
                  Placeholder(
                    fallbackWidth: 50,
                    fallbackHeight: 50,
                    color: Colors.grey.shade800,
                  ),
                  const SizedBox(width: 20),
                  //Blooper Search Icon
                  Placeholder(
                    fallbackWidth: 250,
                    fallbackHeight: 50,
                    color: Colors.grey.shade800,
                  ),
                  const SizedBox(width: 20),
                  //Serach Bar
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        fontFamily: 'IRANSans',
                        fontSize: 32,
                      ),
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'جستجوی خود را وارد کنید...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide: BorderSide(
                            width: 3,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        prefixIcon: Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: IconButton(
                            hoverColor: Colors.grey.withOpacity(0.15),
                            onPressed: () => print('Submit the data!'),
                            icon: Icon(
                              Icons.search,
                              color: Colors.grey.shade700,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      onSubmitted: (value) => print('Submitted: ' + value),
                    ),
                  ),
                ],
              ),
            ),

            //Results text view
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 200),
              child: const Text(
                'Found 2500 results in 3 seconds for the query: Hello World!',
                style: TextStyle(
                  fontFamily: 'Segoe_UI',
                  fontSize: 18,
                ),
              ),
            ),

            //Result Cards
            const SingleChildScrollView(
              child: Text(
                'Search Results:\n...',
              ),
            ),

            //TODO: Pagination
          ],
        ),
      ),
    );
  }
}
