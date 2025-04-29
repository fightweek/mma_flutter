import 'package:flutter/material.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(child: Center(
      child: Text('HomeScreen',style: TextStyle(
        color: Colors.white,
        fontSize: 50
      ),),
    ));
  }
}
