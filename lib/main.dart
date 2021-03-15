import 'package:flutter/material.dart';
import 'package:viidieo_call/screens/home_page.dart';
import 'package:viidieo_call/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lp cam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePagetwo(),
    );
  }
}