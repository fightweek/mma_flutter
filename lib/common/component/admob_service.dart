import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService{
  static String get bannerAdUnitId{
    if(Platform.isAndroid){
      return 'ca-app-pub-3940256099942544/6300978111';
    }else{
      return 'ca-app-pub-3940256099942544/2934735716';
    }
  }

  static String get rewardAdUnitId{
    if(Platform.isAndroid){
      return 'ca-app-pub-3940256099942544/5224354917';
    }else{
      return 'ca-app-pub-3940256099942544/1712485313';
    }
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('ad loaded'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('failed to load, error = $error');
    },
    onAdOpened: (ad) => debugPrint('ad opended'),
    onAdClosed: (ad) => debugPrint('ad closed'),
  );
}