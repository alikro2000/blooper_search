import 'dart:io';

import 'package:http/http.dart';
import 'package:html/parser.dart' as parser;

import 'html_document.dart';
import 'indexer.dart';

class DocumentProcessor {
  final Indexer _indexer;

  DocumentProcessor(this._indexer);

  Future<void> processDoc(HtmlDocument htmlDocument) async {
    var doc = parser.parse(parser.parse(htmlDocument.htmlContent).body!.text);
    //TODO: normalize words before processing
    for(String element in doc.getElementsByTagName('title').map((e) => e.text.trim())) {
      // print(element);
      await _indexer.index(htmlDocument.docID, element, 't');
    }
    for(String element in doc.getElementsByTagName('body').map((e) => e.text.trim())) {
      // print(element);
      await _indexer.index(htmlDocument.docID, element, 'b');
    }
  }

  static String getSnippet(HtmlDocument htmlDocument) {
    var doc = parser.parse(parser.parse(htmlDocument.htmlContent).body!.text);
    return doc.getElementsByTagName('body').map((e) => e.text.trim()).join(' ');
  }
}