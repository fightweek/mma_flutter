import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/fight_event/screen/fight_event_screen.dart';
import 'package:mma_flutter/fighter/screen/search_screen.dart';
import 'package:mma_flutter/game/screen/game_main_screen.dart';
import 'package:mma_flutter/user/screen/logout_screen.dart';
import 'package:mma_flutter/home/screen/home_screen.dart';

class RootTab extends ConsumerStatefulWidget {
  static String get routeName => 'home';

  const RootTab({super.key});

  @override
  ConsumerState<RootTab> createState() => _RootTabState();
}

class _RootTabState extends ConsumerState<RootTab>
    with SingleTickerProviderStateMixin {
  late final TabController controller;
  int index = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 5, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: DARK_GREY_COLOR,
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.gamepad_outlined),
          //   label: '게임',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: '경기 일정',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.gamepad_outlined), label: '게임'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        ],
      ),
      child: TabBarView(
        // TabBarView 간 스크롤(좌우) 불가
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          HomeScreen(),
          FightEventScreen(),
          // Center(child: Text('게임 화면')),
          GameMainScreen(),
          SearchScreen(),
          LogoutScreen(),
        ],
      ),
    );
  }
}
