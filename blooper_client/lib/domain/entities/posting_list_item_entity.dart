class PostingListItemEntity {
  int docID;
  int score;
  String url;
  String title;
  String snippet;

  PostingListItemEntity({
    required this.docID,
    required this.score,
    required this.url,
    required this.title,
    required this.snippet,
  });
}
