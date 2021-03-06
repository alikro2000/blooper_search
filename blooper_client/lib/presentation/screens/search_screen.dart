// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:blooper_client/presentation/bloc/get_query_cubit.dart';
import 'package:blooper_client/presentation/bloc/pagination_cubit.dart';
import 'package:blooper_client/presentation/screens/search_header_widget.dart';
import 'package:blooper_client/presentation/screens/search_info_widget.dart';
import 'package:blooper_client/presentation/screens/search_pagination_widget.dart';
import 'package:blooper_client/presentation/screens/search_result_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetIt.instance<GetQueryCubit>()),
        BlocProvider(create: (context) => GetIt.instance<PaginationCubit>()),
      ],
      child: Scaffold(
        body: Scrollbar(
          controller: _scrollController,
          isAlwaysShown: true,
          // interactive: false,
          thickness: 12,
          showTrackOnHover: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Header and Search bar
                const SearchHeader(),
        
                //Results text view
                const SearchInfo(),
        
                //Pagination
                const SearchPaginationWidget(),
        
                //Result Cards
                const SearchResultList(),
        
                //Pagination
                const SearchPaginationWidget(),
        
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
