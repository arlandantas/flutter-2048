import 'package:flutter/material.dart';
import 'package:flutter2048/pages/game_page.dart';
import 'package:flutter2048/pages/testing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 2048',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const GamePage(),
    );
  }
}
