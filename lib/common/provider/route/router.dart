import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/common/view/root_tab.dart';
import 'package:mma_flutter/common/view/splash_screen.dart';
import 'package:mma_flutter/user/provider/auth_change_provider.dart';
import 'package:mma_flutter/user/screen/login_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final provider = ref.read(authChangeProvider);
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => RootTab(),
        routes: [],
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
    ],
    initialLocation: '/splash',
    refreshListenable: provider,
    redirect: (context, state) {
      return provider.redirectLogic(state);
    },
  );
});
