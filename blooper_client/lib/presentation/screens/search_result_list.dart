import 'package:blooper_client/presentation/bloc/get_query_cubit.dart';
import 'package:blooper_client/presentation/bloc/get_query_state.dart';
import 'package:blooper_client/presentation/screens/search_result_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SearchResultList extends StatelessWidget {
  const SearchResultList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder(
        bloc: GetIt.instance<GetQueryCubit>(),
        builder: (context, state) {
          if (state is GetQueryStateInitial) {
            return const Text('');
          } else if (state is GetQueryStateLoading) {
            return const CircularProgressIndicator();
          } else if (state is GetQueryStateLoaded) {
            return Expanded(
              child: Column(
                  children: state.result.postingList
                      .map((e) => SearchResultListItem(
                          title: e.title,
                          url: e.url,
                          snippet: e.snippet,
                          score: e.score))
                      .toList()),
            );
          } else if (state is GetQueryStateError) {
            return Text(
                '[An error occurred!]: type=${state.error.errorType}, msg=${state.error.message}');
          } else {
            return const Text('[Unsupported state!]');
          }
        },
      ),
    );
  }
}
