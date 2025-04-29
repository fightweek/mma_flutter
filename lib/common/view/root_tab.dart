import 'package:flutter/material.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/common/view/splash_screen.dart';
import 'package:mma_flutter/user/screen/logout_screen.dart';

class RootTab extends StatefulWidget {
  static String get routeName => 'home';

  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 6, vsync: this);
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backGroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: RED_COLOR,
        unselectedItemColor: PRIMARY_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '홈'),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad_outlined),
            label: '게임',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: '뉴스'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: '게시판'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
          BottomNavigationBarItem(icon: Icon(Icons.circle_outlined),label: '로딩'),
        ],
      ),
      child: TabBarView(
        // TabBarView 간 스크롤(좌우) 불가
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          Center(child: Text('홈 화면')),
          Center(child: Text('게임 화면')),
          Center(child: Text('뉴스 화면')),
          Center(child: Text('게시판')),
          LogoutScreen(),
          SplashScreen(),
        ],
      ),
    );
  }
}
