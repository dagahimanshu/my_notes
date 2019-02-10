import 'package:flutter/material.dart';
import 'package:my_notes/screens/notelist.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
      home: notelist(),

    );
  }
}