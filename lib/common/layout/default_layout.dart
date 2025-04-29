import 'package:flutter/material.dart';
import 'package:mma_flutter/common/const/colors.dart';

class DefaultLayout extends StatelessWidget {
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget child;
  final Color? backGroundColor;

  const DefaultLayout({
    required this.child,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backGroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      appBar: renderAppBar(),
      backgroundColor: backGroundColor ?? BACKGROUND_COLOR,
      body: child,
    );
  }

  AppBar renderAppBar() {
    return AppBar(
      backgroundColor: PRIMARY_COLOR,
      title: Image.asset('asset/img/logo/fight_week.png', width: 50),
      centerTitle: true,
    );
  }
}
