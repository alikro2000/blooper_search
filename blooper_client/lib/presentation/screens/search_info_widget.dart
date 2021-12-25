import 'package:blooper_client/presentation/bloc/get_query_cubit.dart';
import 'package:blooper_client/presentation/bloc/get_query_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SearchInfo extends StatelessWidget {
  const SearchInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 200),
      child: BlocBuilder(
        bloc: GetIt.instance<GetQueryCubit>(),
        builder: (context, state) {
          String result = '';
          if (state is GetQueryStateInitial) {
            ;
          } else if (state is GetQueryStateLoading) {
            result = 'Query submitted, waiting for response...';
          } else if (state is GetQueryStateLoaded) {
            result =
                'Found ${state.result.count} result(s) in ${state.result.duration} for the query ${state.result.query}';
          } else if (state is GetQueryStateError) {
            result =
                '[An error occurred]: type=${state.error.errorType}, msg=${state.error.message}';
          } else {
            result = '[Unsupported state!]';
          }
          return Text(
            result,
            style: const TextStyle(
              fontFamily: 'Segoe_UI',
              fontSize: 18,
            ),
          );
        },
      ),
    );
  }
}
