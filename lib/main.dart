import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mma_flutter/admin/news/screen/news_upload_screen.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/notification/local_notifications.dart';
import 'package:mma_flutter/common/provider/route/router.dart';
import 'package:mma_flutter/firebase_options.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      FlutterLocalNotificationsPlugin().show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'channel_1',
            '좋아하는 선수 경기 알림',
            importance: Importance.defaultImportance,
            priority: Priority.high,
          ),
        ),
      );
    }
  });
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
      child: Builder(
        builder: (context) {
          final mediaQuery = MediaQueryData.fromView(View.of(context));

          final screenWidth = mediaQuery.size.width;
          final screenHeight = mediaQuery.size.height;

          // 실제 기기 SafeArea 제외 높이
          final safeHeight =
              screenHeight - mediaQuery.padding.top - mediaQuery.padding.bottom;

          // 피그마 기준
          const figmaWidth = 402.0;
          const figmaHeight = 874.0;

          // 피그마 비율 유지 → 실제 기기 safeHeight를 피그마 874에 매핑
          final designHeight = safeHeight / (screenWidth / figmaWidth);

          debugPrint("Device size: $screenWidth x $screenHeight");
          debugPrint("SafeArea height: $safeHeight");
          debugPrint("Calculated designHeight: $designHeight");

          return ScreenUtilInit(
            designSize: Size(figmaWidth, designHeight),
            minTextAdapt: true,
            builder: (_, __) => _App(),
          );
        },
      ),
    ),
  );
}

class _App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      locale: const Locale('ko', 'KR'),
      // 기본 언어 한국어
      supportedLocales: const [Locale('en', 'US'), Locale('ko', 'KR')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(fontFamily: 'NotoSans'),
      routerConfig: router,
    );
  }
}
