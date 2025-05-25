import 'package:flutter/material.dart';

class AppButtonPage extends StatefulWidget {
  const AppButtonPage({super.key});

  @override
  State<AppButtonPage> createState() => _AppButtonPageState();
}

class _AppButtonPageState extends State<AppButtonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppButton"),
        backgroundColor: Colors.pink[100],
      ),
    );
  }
}
