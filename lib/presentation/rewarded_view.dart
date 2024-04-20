import 'package:flutter/material.dart';
import 'package:google_admob/core/utils/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedView extends StatefulWidget {
  const RewardedView({super.key});

  @override
  State<RewardedView> createState() => _RewardedViewState();
}

class _RewardedViewState extends State<RewardedView> {
  static const int maxFailedLoadAttempts = 3;
  late RewardedAd _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  @override
  void initState() {
    super.initState();
    _createRewardedAd();
  }

  @override
  void dispose() {
    super.dispose();
    _rewardedAd.dispose();
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd() {
    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd.setImmersiveMode(true);
    _rewardedAd.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: const Center(
          child: Text('Rewarded ads'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showRewardedAd();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
