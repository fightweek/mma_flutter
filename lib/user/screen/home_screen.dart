import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeScreen'),
      ),
      body: Container(
        color: Colors.blue,
        height: 300,
        width: 300,
      ),
    );
  }
}
