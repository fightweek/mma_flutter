import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/provider/route/router.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "asset/config/.env");
  NaverLoginSDK.initialize(
    clientId: dotenv.get('NAVER_CLIENT_ID'),
    clientSecret: dotenv.get('NAVER_CLIENT_SECRET'),
  );
  runApp(ProviderScope(child: _App()));
}

class _App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
    );
  }
}
