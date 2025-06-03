// main.dart
import 'package:flutter/material.dart';

import 'TEST_FOLDER/test_file.dart';
import 'Views/home/home_view/main_screen.dart';

void main() {
  runApp(const TizaraaApp());
}

class TizaraaApp extends StatelessWidget {
  const TizaraaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tizaraa - Online Shopping',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFFFF6B35),
        scaffoldBackgroundColor: Colors.grey[50],
        fontFamily: 'Roboto',
      ),
      home: const TaxReturn(),//MainScreen
      debugShowCheckedModeBanner: false,
    );
  }
}


