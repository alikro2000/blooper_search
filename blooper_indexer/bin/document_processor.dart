import 'dart:io';

import 'package:html/parser.dart' as parser;

import 'html_document.dart';
import 'indexer.dart';

class DocumentProcessor {
  final Indexer _indexer;

  DocumentProcessor(this._indexer);

  Future<void> processDoc(HtmlDocument htmlDocument) async {
    await _indexer.index(htmlDocument.docID, getTitle(htmlDocument), 't');
    await _indexer.index(htmlDocument.docID, getBody(htmlDocument), 'b');
  }

  static String getTitle(HtmlDocument htmlDocument) {
    var doc = parser.parse(htmlDocument.htmlContent);
    return parser
        .parse(doc.outerHtml)
        .getElementsByTagName('title')
        .map((e) => e.text.trim())
        .join();
  }

  static String getBody(HtmlDocument htmlDocument) {
    var doc = parser.parse(parser.parse(htmlDocument.htmlContent).body!.text);
    return doc.getElementsByTagName('body').map((e) => e.text.trim()).join();
  }

  static String getSnippet(HtmlDocument htmlDocument) {
    var doc = parser.parse(parser.parse(htmlDocument.htmlContent).body!.text);
    return doc.getElementsByTagName('body').map((e) => e.text.trim()).join(' ');
  }
}
