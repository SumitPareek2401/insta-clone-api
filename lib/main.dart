import 'package:flutter/material.dart';
import 'package:sync_ventures_ig_api/ig_api_user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      
      home: InstagramScreen(),
    );
  }
}

