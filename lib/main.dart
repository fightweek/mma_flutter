import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mma_flutter/admin/news/screen/news_upload_screen.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/notification/local_notifications.dart';
import 'package:mma_flutter/common/provider/route/router.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  final navigatorKey = GlobalKey<NavigatorState>();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();

  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Chain) {
      return stack.toTrace();
    }
    return stack;
  };
  await initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  await LocalNotifications.init();
  // 앱이 종료된 상태에서 푸시 알림을 탭할 때
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState?.pushNamed('/');
    });
  }

  ip = await isEmulator() ? emulatorIp : localNetworkIp;

  await dotenv.load(fileName: "asset/config/.env");
  KakaoSdk.init(
    nativeAppKey: dotenv.get('KAKAO_NATIVE_APP_KEY'),
    javaScriptAppKey: dotenv.get("KAKAO_JS_KEY"),
  );
  NaverLoginSDK.initialize(
    clientId: dotenv.get('NAVER_CLIENT_ID'),
    clientSecret: dotenv.get('NAVER_CLIENT_SECRET'),
  );
  runApp(
    ProviderScope(
      child: ScreenUtilInit(designSize: Size(402, 874), child: _App()),
    ),
  );
}

class _App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      theme: ThemeData(fontFamily: 'NotoSans'),
      routerConfig: router,
    );
  }
}
