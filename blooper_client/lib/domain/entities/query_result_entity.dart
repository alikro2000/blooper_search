import 'package:blooper_client/domain/entities/posting_list_item_entity.dart';

class QueryResultEntity {
  String query;
  int count;
  var duration;
  List<PostingListItemEntity> postingList;

  QueryResultEntity({
    required this.query,
    required this.count,
    required this.duration,
    required this.postingList,
  });
}
