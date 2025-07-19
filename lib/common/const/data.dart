import 'dart:io' as data;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

final emulatorIp = '10.0.2.2:8080';
final simulatorIp = '127.0.0.1:8080';
final localNetworkIp = '192.168.219.48:8080';
late final ip;
// final ip = data.Platform.isIOS ? simulatorIp : emulatorIp;
// final ip = '192.168.0.13:8080';

// Future<String> get ip async => await isEmulator() ? emulatorIp : localNetworkIp;
// final ip = await isEmulator() ? emulatorIp : localNetworkIp;
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

final Map<String, String> weightClassMap = {
  'Women\'s Flyweight' : '여성 플라이급',
  'Strawweight': '스트로급',
  'Flyweight': '플라이급',
  'Bantamweight': '벤텀급',
  'Featherweight': '페더급',
  'Lightweight': '라이트급',
  'Welterweight': '웰터급',
  'Middleweight': '미들급',
  'Light Heavyweight': '라이트 헤비급',
  'Heavyweight' : '헤비급'
};

Icon tierIcon(int point){
  switch(point){
    case < 10000:
      return Icon(Icons.star,color: Colors.white,);
    case < 10000:
      return Icon(Icons.star,color: Colors.blue,);
    case < 10000:
      return Icon(Icons.star,color: Colors.purple,);
    case < 10000:
      return Icon(Icons.star,color: Colors.brown,);
    default:
      return Icon(Icons.star,color: Colors.black,);
  }
}

final newsSources = ['MMA_JUNKIE','MMA_FIGHTING','UFC','ESPN_MMA','MMA_PROS_PICK','ELSE'];
final newsTypes = ['IMAGES','IMAGES_TRANSLATION','NO_IMAGES'];

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