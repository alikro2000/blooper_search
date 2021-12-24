class HtmlDocument {
  final int docID;
  final String url;
  final String htmlContent;

  HtmlDocument({
    required this.docID,
    required this.url,
    required this.htmlContent,
  });

  factory HtmlDocument.fromJson(dynamic data) {
    return HtmlDocument(
      docID: data['docID'],
      url: data['url'],
      htmlContent: data['htmlContent'],
    );
  }

  @override
  String toString({bool hasHtml = false}) {
    return 'HtmlDoc: docID=$docID, url=$url${hasHtml ? ', htmlContent=$htmlContent' : ''}';
  }

  Map<String, dynamic> toJson() {
    return {
      'docID': docID,
      'url': url,
      'htmlContent': htmlContent,
    };
  }
}
