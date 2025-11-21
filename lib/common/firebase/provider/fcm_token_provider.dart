import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseFcmTokenProvider = Provider<FcmTokenProvider>((ref) {
  return FirebaseFcmTokenProvider();
});

abstract class FcmTokenProvider {
  Future<String?> getToken();
}

class FirebaseFcmTokenProvider implements FcmTokenProvider {
  @override
  Future<String?> getToken() {
    return FirebaseMessaging.instance.getToken();
  }
}
