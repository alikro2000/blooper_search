import 'package:blooper_client/presentation/bloc/get_query_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              onSubmitted: (value) =>
                  GetIt.instance<GetQueryCubit>().submitQuery(value),
            ),
          ),
        ],
      ),
    );
  }
}
