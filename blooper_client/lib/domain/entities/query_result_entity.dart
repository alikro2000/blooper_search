class QueryResultEntity {
  String query;
  int count;
  var duration;
  List<Map> postingList;

  QueryResultEntity({
    required this.query,
    required this.count,
    required this.duration,
    required this.postingList,
  });
}
