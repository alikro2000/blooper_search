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
                GetIt.instance<PaginationCubit>().getCurrentPage() + 1;
            List<Widget> numbersWidgets = [];
            numbersWidgets.add(const PaginationListItem(indice: 1));
            bool leftDotsFlag = false;
            for (int i = 2; i <= currentPage; ++i) {
              if (i >= currentPage - 3) {
                numbersWidgets.add(PaginationListItem(indice: i));
              } else if (!leftDotsFlag) {
                numbersWidgets.add(const Text('...'));
                leftDotsFlag = true;
              }
            }
            bool rightDotsFlag = false;
            for (int i = currentPage + 1; i < pagesCount; ++i) {
              if (i <= currentPage + 3) {
                numbersWidgets.add(PaginationListItem(indice: i));
              } else if (!rightDotsFlag) {
                numbersWidgets.add(const Text('...'));
                rightDotsFlag = true;
              }
            }
            numbersWidgets.add(PaginationListItem(indice: pagesCount));

            return Wrap(
              alignment: WrapAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: numbersWidgets,
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

class PaginationListItem extends StatelessWidget {
  final int indice;

  const PaginationListItem({
    Key? key,
    required this.indice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentPage = GetIt.instance<PaginationCubit>().getCurrentPage();
    return InkWell(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Text(
          '$indice',
          style: TextStyle(
            color: Colors.blue.shade700,
            decoration:
                indice == currentPage + 1 ? TextDecoration.underline : null,
          ),
        ),
      ),
      onTap: () => GetIt.instance<PaginationCubit>().setPage(indice - 1),
      hoverColor: Colors.white.withOpacity(0),
    );
  }
}
