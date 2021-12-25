import 'package:blooper_client/presentation/bloc/pagination_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SearchPaginationWidget extends StatelessWidget {
  const SearchPaginationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: BlocBuilder(
          bloc: GetIt.instance<PaginationCubit>(),
          builder: (context, List state) {
            if (state.isEmpty) {
              return Container();
              // return const Text('Waiting for Query...');
            }
            int pagesCount = GetIt.instance<PaginationCubit>().getPagesCount();
            int currentPage =
                GetIt.instance<PaginationCubit>().getCurrentPage();
            return Wrap(
              alignment: WrapAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pagesCount, (index) => index + 1)
                  .map((e) => InkWell(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            '$e',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              decoration: e == currentPage + 1
                                  ? TextDecoration.underline
                                  : null,
                            ),
                          ),
                        ),
                        onTap: () =>
                            GetIt.instance<PaginationCubit>().setPage(e - 1),
                        hoverColor: Colors.white.withOpacity(0),
                      ))
                  .toList(),
            );
          }),
      // child: ListView.separated(
      //   itemCount: 5,
      //   scrollDirection: Axis.horizontal,
      //   itemBuilder: (context, index) => Center(child: Text('$index')),
      //   separatorBuilder: (context, index) => const SizedBox(width: 10),
      // ),
    );
  }
}
