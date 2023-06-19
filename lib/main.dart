import 'package:flutter/material.dart';
import 'package:sync_ventures_ig_api/new_ig_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facebook Graph API Demo',
      home: InstagramScreennew(),
    );
  }
}
