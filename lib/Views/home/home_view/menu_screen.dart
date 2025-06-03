import 'package:flutter/material.dart';


class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Menu'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Menu Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}