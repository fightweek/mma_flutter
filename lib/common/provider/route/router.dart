import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/common/screen/root_tab.dart';
import 'package:mma_flutter/common/screen/splash_screen.dart';
import 'package:mma_flutter/fight_event/screen/fight_event_detail_screen.dart';
import 'package:mma_flutter/fighter/screen/fighter_detail_screen.dart';
import 'package:mma_flutter/game/screen/game_main_screen.dart';
import 'package:mma_flutter/admin/news/screen/news_upload_screen.dart';
import 'package:mma_flutter/user/provider/auth_change_provider.dart';
import 'package:mma_flutter/user/screen/init_nickname_screen.dart';
import 'package:mma_flutter/user/screen/login_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final provider = ref.read(authChangeProvider);
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => RootTab(),
        routes: [
          GoRoute(
            path: 'fighter_detail/:id',
            name: FighterDetailScreen.routeName,
            builder: (context, state) {
              return FighterDetailScreen(
                id: int.parse(state.pathParameters['id']!),
              );
            },
          ),
          // GoRoute(
          //   path: 'event_detail/:date',
          //   name: FightEventDetailScreen.routeName,
          //   builder: (context, state) {
          //     return FightEventDetailScreen(
          //       date: DateTime.parse(state.pathParameters['date']!),
          //     );
          //   },
          // ),
          GoRoute(
            path: NewsUploadScreen.routeName,
            name: NewsUploadScreen.routeName,
            builder: (context, state) {
              return NewsUploadScreen();
            },
          ),
          GoRoute(
            path: GameMainScreen.routeName,
            name: GameMainScreen.routeName,
            builder: (context, state) {
              return GameMainScreen();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        name: LoginScreen.routeName,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/splash',
        name: SplashScreen.routeName,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/init_nickname',
        name: InitNicknameScreen.routeName,
        builder: (context, state) => InitNicknameScreen(),
      ),
    ],
    initialLocation: '/splash',
    refreshListenable: provider,

    /// provider 상태 변경될 때 redirect 실행
    redirect: (context, state) {
      return provider.redirectLogic(state);
    },
  );
});
