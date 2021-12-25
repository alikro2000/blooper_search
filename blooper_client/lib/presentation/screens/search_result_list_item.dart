import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'dart:html' as html;

class SearchResultListItem extends StatelessWidget {
  final String title;
  final String url;
  final String snippet;
  final int score;

  const SearchResultListItem({
    Key? key,
    required this.title,
    required this.url,
    required this.snippet,
    required this.score,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1500,
      height: 300,
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Title
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //url
                // RichText(
                //   text: TextSpan(
                //       text: url,
                //       style: TextStyle(
                //         overflow: TextOverflow.fade,
                //         color: Colors.blue.shade700,
                //         decoration: TextDecoration.underline,
                //         fontFamily: 'Segoe_UI',
                //         fontSize: 14,
                //       ),
                //       recognizer: TapGestureRecognizer()
                //         ..onTap = () => html.window.open(url, title)),
                // ),
                //title
                RichText(
                  text: TextSpan(
                      text: title,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        decoration: TextDecoration.underline,
                        fontFamily: 'IRANSans',
                        fontSize: 24,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => html.window.open(url, title)),
                ),
              ],
            ),
          ),
          //Snippet
          Text(
            snippet,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            maxLines: 5,
            style: const TextStyle(
              color: Colors.grey,
              fontFamily: 'IRANSans',
              overflow: TextOverflow.ellipsis,
              fontSize: 20,
            ),
          ),
          //Score
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Score: $score',
              style: const TextStyle(
                fontFamily: 'Segoe_UI',
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
