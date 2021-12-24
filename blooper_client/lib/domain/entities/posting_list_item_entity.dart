class PostingListItemEntity {
  int docID;
  int score;
  String url;
  String snippet;

  PostingListItemEntity({
    required this.docID,
    required this.score,
    required this.url,
    required this.snippet,
  });
}
