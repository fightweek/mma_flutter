import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/user/enumtype/login_platform.dart';

final socialProvider = StateProvider<LoginPlatform>((ref) {
  return LoginPlatform.none;
},);