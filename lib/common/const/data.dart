import 'dart:io' as data;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/stream/bet/model/bet_request_model.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

final emulatorIp = '10.0.2.2:8080';
final simulatorIp = '127.0.0.1:8080';
final localNetworkIp = '10.173.152.108:8080';
late final ip;
// final ip = data.Platform.isIOS ? simulatorIp : emulatorIp;
// final ip = '192.168.0.13:8080';

// Future<String> get ip async => await isEmulator() ? emulatorIp : localNetworkIp;
// final ip = await isEmulator() ? emulatorIp : localNetworkIp;
final storage = FlutterSecureStorage();

final Map<String, String> weightClassMap = {
  'Women\'s Flyweight': '여성 플라이급',
  'Women\'s Strawweight': '스트로급',
  'Flyweight': '플라이급',
  'Bantamweight': '벤텀급',
  'Featherweight': '페더급',
  'Lightweight': '라이트급',
  'Welterweight': '웰터급',
  'Middleweight': '미들급',
  'Light Heavyweight': '라이트 헤비급',
  'Heavyweight': '헤비급',
};

final Map<WinMethod, String> winMethodMap = {
  WinMethod.sub : '서브미션',
  WinMethod.koTko : 'KO/TKO',
  WinMethod.sDec : '판정(스플릿)',
  WinMethod.mDec : '판정(다수결)',
  WinMethod.uDec : '판정(만장일치)',
};

Icon tierIcon(int point) {
  switch (point) {
    case < 10000:
      return Icon(Icons.star, color: Colors.white);
    case < 10000:
      return Icon(Icons.star, color: Colors.blue);
    case < 10000:
      return Icon(Icons.star, color: Colors.purple);
    case < 10000:
      return Icon(Icons.star, color: Colors.brown);
    default:
      return Icon(Icons.star, color: Colors.black);
  }
}

final newsSources = [
  'MMA_JUNKIE',
  'MMA_FIGHTING',
  'UFC',
  'ESPN_MMA',
  'MMA_PROS_PICK',
  'ELSE',
];
final newsTypes = ['IMAGES', 'IMAGES_TRANSLATION', 'NO_IMAGES'];

final easyGameDescription = '랭커 & 잘 알려진 선수';
final hardGameDescription = '모든 UFC 선수';

Future<bool> isEmulator() async {
  final deviceInfo = DeviceInfoPlugin();

  if (data.Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.isPhysicalDevice == false ||
        androidInfo.fingerprint.contains("generic") ||
        androidInfo.model.contains("Emulator") ||
        androidInfo.brand.contains("generic");
  } else if (data.Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.isPhysicalDevice == false;
  }

  return false;
}

final betDescription = ''
    '승자 예측 성공: 2배\n\n'
    'KO/서브미션 예측 성공: 4배\n\n'
    'KO/서브미션 + 라운드 예측 성공: 8배\n\n'
    '판정승 예측 성공: 3배\n\n'
    '무승부 예측 성공: 30배\n\n';
