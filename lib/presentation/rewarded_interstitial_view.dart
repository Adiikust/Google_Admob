import 'package:flutter/material.dart';
import 'package:google_admob/core/utils/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedInterstitialView extends StatefulWidget {
  const RewardedInterstitialView({super.key});

  @override
  State<RewardedInterstitialView> createState() =>
      _RewardedInterstitialViewState();
}

class _RewardedInterstitialViewState extends State<RewardedInterstitialView> {
  ///Rewarded interstitial
  late RewardedInterstitialAd _rewardedInterstitialAd;
  int _numRewardedInterstitialLoadAttempts = 0;
  static const int maxFailedLoadAttempts = 3;

  @override
  void initState() {
    super.initState();
    _createRewardedInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();
    _rewardedInterstitialAd.dispose();
  }

  void _createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: AdHelper.rewardedInterstitialAdUnitId,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            print('$ad loaded.');
            _rewardedInterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedInterstitialAd failed to load: $error');
            _numRewardedInterstitialLoadAttempts += 1;
            if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedInterstitialAd();
            }
          },
        ));
  }

  void _showRewardedInterstitialAd() {
    _rewardedInterstitialAd.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedInterstitialAd();
      },
      onAdFailedToShowFullScreenContent:
          (RewardedInterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedInterstitialAd();
      },
    );
    _rewardedInterstitialAd.setImmersiveMode(true);
    _rewardedInterstitialAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: const Center(
          child: Text('Rewarded interstitial ads'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showRewardedInterstitialAd();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
