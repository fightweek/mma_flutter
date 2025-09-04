import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
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
  int index = 2;

  @override
  void initState() {
    print('init root tab');
    super.initState();
    controller = TabController(length: 5, vsync: this, initialIndex: index);
    controller.addListener(tabListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    index =
        int.tryParse(GoRouterState.of(context).queryParameters['tab'] ?? '2') ??
        2;
  }

  @override
  void dispose() {
    print('dispose root_tab');
    controller.removeListener(tabListener);
    controller.dispose();
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
        selectedItemColor: WHITE_COLOR,
        unselectedItemColor: WHITE_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('asset/img/icon/bet.png'),
            label: 'Bet',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('asset/img/icon/quiz.png'),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('asset/img/icon/home.png'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('asset/img/icon/schedule.png'),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('asset/img/icon/profile.png'),
            label: 'Profile',
          ),
        ],
      ),
      child: TabBarView(
        // TabBarView 간 스크롤(좌우) 불가
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          Container(
            child: Center(child: Text('배팅 뷰', style: defaultTextStyle)),
          ),
          // SearchScreen(),
          GameMainScreen(),
          // Center(child: Text('게임 화면')),
          HomeScreen(),
          FightEventScreen(),
          LogoutScreen(),
        ],
      ),
    );
  }
}
