import 'package:bloc/bloc.dart';
import 'package:blooper_client/domain/entities/posting_list_item_entity.dart';

class PaginationCubit extends Cubit<List<PostingListItemEntity>> {
  late List<PostingListItemEntity> _postingListItems;
  late int _pagesCount;
  late int _currentPage;

  PaginationCubit() : super([]);

  int getPagesCount() => _pagesCount;

  int getCurrentPage() => _currentPage;

  void init(List<PostingListItemEntity> postingListItems) {
    this._currentPage = 0;
    this._postingListItems = postingListItems;
    emit(postingListItems
        .getRange(
          0,
          10 < postingListItems.length ? 10 : postingListItems.length,
        )
        .toList());
    _pagesCount = postingListItems.length ~/ 10;
    _pagesCount += (postingListItems.length % 10 == 0 ? 0 : 1);
  }

  void setPage(int pageNumber) {
    this._currentPage = pageNumber;
    int rightIndex = pageNumber * 10 + 10;
    emit(_postingListItems
        .getRange(
          pageNumber * 10,
          rightIndex <= _postingListItems.length
              ? rightIndex
              : _postingListItems.length,
        )
        .toList());
  }
}
