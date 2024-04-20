import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_admob/core/utils/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'presentation/home_page.dart';

AppOpenAd? _appOpenAd;
// bool isAppOpenAd = false;
Future<void> loadAppOpenAd() async {
  await AppOpenAd.load(
    adUnitId: AdHelper.appOpenAdUnitId,
    request: const AdRequest(),
    adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
      print('Ad loaded.');
      _appOpenAd = ad;
      _appOpenAd!.show();
    }, onAdFailedToLoad: (error) {
      print('Failed to load ad: $error');
    }),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  loadAppOpenAd();
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admob Ads',
      home: HomePage(),
    );
  }
}
