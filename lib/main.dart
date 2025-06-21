import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mma_flutter/common/provider/route/router.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
void main() async {
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Chain) {
      return stack.toTrace();
    }
    return stack;
  };
  await initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "asset/config/.env");
  KakaoSdk.init(
    nativeAppKey: dotenv.get('KAKAO_NATIVE_APP_KEY'),
    javaScriptAppKey: dotenv.get("KAKAO_JS_KEY"),
  );
  NaverLoginSDK.initialize(
    clientId: dotenv.get('NAVER_CLIENT_ID'),
    clientSecret: dotenv.get('NAVER_CLIENT_SECRET'),
  );
  await printKeyHash();
  runApp(ProviderScope(child: _App()));
}

Future<void> printKeyHash() async {
  try {
    final keyHash = await KakaoSdk.origin;
    print("현재 사용 중인 키 해시: $keyHash");
  } catch (e) {
    print("키 해시를 가져오는 중 오류 발생: $e");
  }
}

class _App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      routerConfig: router,
      // debugShowCheckedModeBanner: false,
      // routerDelegate: router.routerDelegate,
      // routeInformationProvider: router.routeInformationProvider,
      // routeInformationParser: router.routeInformationParser,
    );
  }
}
