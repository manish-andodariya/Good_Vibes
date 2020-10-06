import 'dart:convert';

import 'package:flutter/material.dart';

class SavedQuotes extends StatefulWidget {
  SavedQuotes({Key key}) : super(key: key);

  @override
  _SavedQuotesState createState() => _SavedQuotesState();
}

class _SavedQuotesState extends State<SavedQuotes> {
  @override
  Widget build(BuildContext context) {
    List saved = (ModalRoute.of(context).settings.arguments);
    return Scaffold(
      appBar: AppBar(),
      body: new ListView.builder(
          itemCount: saved == null ? 0 : saved.length,
          itemBuilder: (BuildContext context, i) {
            String realquotes = "${saved[i]["text"]}";
            String realAuthor = "${saved[i]["author"]}";
            print(realquotes + realAuthor + "\n");
            if (realAuthor == "null") {
              realAuthor = "Anonymous";
            } else {
              realAuthor = realAuthor;
            }

            return new Card(
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      '"' + '$realquotes' + '"',
                      style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        '-- $realAuthor',
                        style: TextStyle(
                            letterSpacing: 2.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.amberAccent),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
