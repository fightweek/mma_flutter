import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mma_flutter/common/component/admob_service.dart';

final rewardedAdProvider = ChangeNotifierProvider<RewardedAdManager>((ref) {
  print('init rewardedAdProvider');
  return RewardedAdManager()..loadAd();
},);

class RewardedAdManager extends ChangeNotifier{
  RewardedAd? _rewardedAd;

  bool get isAdReady => _rewardedAd != null;

  void loadAd() {
    RewardedAd.load(
      adUnitId: AdMobService.rewardAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          _rewardedAd = ad;
          notifyListeners();
        },
        onAdFailedToLoad: (error) {
          debugPrint('RewardedAd failed to load: $error');
          _rewardedAd = null;
          notifyListeners();
        },
      ),
    );
  }

  void showRewardedAd(Function(RewardItem) onRewarded) {
    if (_rewardedAd == null) {
      print('Rewarded Ad not ready');
      loadAd();
      return;
    }

    /// 광고 로딩 성공적일 때 실행되는 콜백이며, 해당 콜백 내부에 다른 여러 가지 콜백 함수 존재
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      /// 광고가 전체 화면으로 성공적으로 표시되었을 때 실행됨
      onAdDismissedFullScreenContent: (ad) {
        print('user stopped while watching ad');
        loadAd();
      },

      /// 사용자가 광고를 닫았을 때 실행됨
      onAdWillDismissFullScreenContent: (ad) {
        print('Rewarded Ad dismissed');
        ad.dispose();
        loadAd(); // 다음 광고를 위해 미리 로드
      },

      /// 표시 도중 실패했을 때 실행됨
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('Rewarded Ad failed to show: $error');
        ad.dispose();
        loadAd();
      },
    );
    /// SDK 광고 UI 실행
    _rewardedAd!.show(
      /// 유저가 광고를 끝까지 시청하여 보상 요건을 충족했을 때
      onUserEarnedReward: (ad, reward) {
        onRewarded(reward);
        loadAd();
      },
    );
  }
}
