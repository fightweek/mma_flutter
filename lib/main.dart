import 'package:flutter/material.dart';
import 'package:mma_flutter/user/screen/login_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(primaryColor: Colors.grey),
      home: LoginScreen(),
    ),
  );
}
