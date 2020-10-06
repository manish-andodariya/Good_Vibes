import 'dart:math';
import 'package:flutter/material.dart';
import 'package:good_wibes/saved.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:clipboard/clipboard.dart';
import 'package:share/share.dart';

// Future<List> getQuote() async {
//   final random = Random();
//   vibetemp = new List.generate(20, (_) => vibe[random.nextInt(vibe.length)]);
//   print(vibetemp.length);
//   return vibetemp;
// }

List<dynamic> savedList = [];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final random = Random();
  List vibe;
  List vibetemp;
  bool isLoad = false;

  Future _MakeReq() async {
    String url = 'https://type.fit/api/quotes';
    var responce;
    try {
      responce = await http
          .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
      print(responce.body);
      List data = json.decode(responce.body);
      print(data);
      setState(() {
        vibetemp = data;
      });
      _GetQuote();
    } catch (e) {
      print("Network error!!!");
    }
  }

  Future _GetQuote() async {
    await Future.delayed(Duration(milliseconds: 1500));
    vibe =
        new List.generate(10, (_) => vibetemp[random.nextInt(vibetemp.length)]);
    print(vibe.length);
    setState(() {
      vibe;
      isLoad = true;
    });
  }

  @override
  void initState() {
    _MakeReq();
  }

  // ignore: missing_return
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Good Vibes", style: TextStyle(fontFamily: 'fontbody')),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.bookmark_border_rounded),
              onPressed: () {
                Navigator.of(context).push(_createRoute());
              })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _GetQuote();
          return await Future.delayed(Duration(seconds: 2));
        },
        child: (!isLoad)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitRipple(
                    color: Colors.white,
                    size: 100.0,
                    borderWidth: 12.0,
                  ),
                  Text("Getting Quotes Ready For You :)")
                ],
              )
            : Container(
                child: new ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: vibe == null ? 0 : vibe.length,
                    itemBuilder: (BuildContext context, i) {
                      String realquotes = "${vibe[i]["text"]}";
                      String realAuthor = "${vibe[i]["author"]}";
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ColoredBox(
                                  color: Colors.amber,
                                  child: SizedBox(
                                    height: 1,
                                  ),
                                ),
                              ),
                              Center(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                      iconSize: 22.0,
                                      icon: Icon(Icons.favorite_border_rounded),
                                      color: Colors.white,
                                      onPressed: () {
                                        savedList.add(vibe[i]);
                                        final snackBar = SnackBar(
                                            duration:
                                                Duration(milliseconds: 200),
                                            behavior: SnackBarBehavior.floating,
                                            content: Text('Liked'));
                                        Scaffold.of(context)
                                            .showSnackBar(snackBar);
                                        setState(() {
                                          vibe.removeAt(i);
                                        });
                                      }),
                                  IconButton(
                                      iconSize: 22.0,
                                      icon: Icon(Icons.copy_rounded),
                                      color: Colors.white,
                                      onPressed: () {
                                        print(savedList);
                                        FlutterClipboard.copy(
                                          '"' +
                                              '$realquotes' +
                                              '\n\n'
                                                  '"' +
                                              'By ' +
                                              realAuthor,
                                        ).then((result) {
                                          final snackBar = SnackBar(
                                              duration:
                                                  Duration(milliseconds: 200),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              content: Text('Copied!'));
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                        });
                                      }),
                                  IconButton(
                                      iconSize: 22.0,
                                      icon: Icon(Icons.share),
                                      color: Colors.white,
                                      onPressed: () {
                                        Share.share(
                                          "$realquotes " +
                                              '\n\n' +
                                              'By $realAuthor',
                                        );
                                      }),
                                ],
                              ))
                            ],
                          ),
                        ),
                      );
                    })),
      ),
    );
  }
}

Route _createRoute() {
  return MaterialPageRoute(
      builder: (context) => SavedQuotes(),
      settings: RouteSettings(arguments: savedList));
}
