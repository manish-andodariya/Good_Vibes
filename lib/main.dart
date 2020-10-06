import 'package:flutter/material.dart';
import 'package:good_wibes/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.amberAccent,
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of tflutterext, and more.
        textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 72.0,
              fontFamily: 'fontbody',
              fontWeight: FontWeight.bold),
          headline6: TextStyle(
              fontSize: 36.0,
              fontFamily: 'fontbody',
              fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 16.0, fontFamily: 'fontbody'),
        ),
      ),
      title: 'Material App',
      home: MyHomePage(),
    );
  }
}
