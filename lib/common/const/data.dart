import 'dart:io' as data;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

final emulatorIp = '10.0.2.2:8080';
final simulatorIp = '127.0.0.1:8080';
final ip = data.Platform.isIOS ? simulatorIp : emulatorIp;

final storage = FlutterSecureStorage();

final Map<int, String> weightMap = {
  115: '스트로급',
  125: '플라이급',
  135: '벤텀급',
  145: '페더급',
  155: '라이트급',
  170: '웰터급',
  185: '미들급',
  205: '라이트 헤비급',
};
