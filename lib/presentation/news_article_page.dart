import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_admob/core/utils/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'widgets.dart';

class NewsArticlePage extends StatefulWidget {
  final String title;
  final String imagePath;
  const NewsArticlePage(
      {super.key, required this.title, required this.imagePath});

  @override
  State<NewsArticlePage> createState() => _NewsArticlePageState();
}

class _NewsArticlePageState extends State<NewsArticlePage> {
  late InterstitialAd fullPageAd;
  bool isFullPageAdLoaded = false;
  late BannerAd _bottomBannerAd;
  bool isBottomBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    initializeFullPageAd();
    _initBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    fullPageAd.dispose();
    _bottomBannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isFullPageAdLoaded) {
          fullPageAd.show();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const AppBarTitle(),
          backgroundColor: Colors.indigo[800],
        ),
        body: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(widget.imagePath),
            const SizedBox(height: 20),
            Card(
              color: Colors.indigo[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. \n\nEt harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: isBottomBannerAdLoaded == true
            ? SizedBox(
                height: _bottomBannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bottomBannerAd),
              )
            : Container(height: 0),
      ),
    );
  }

  void initializeFullPageAd() async {
    await InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
        log("Full Page Ad Loaded!");
        fullPageAd = ad;
        setState(() {
          isFullPageAdLoaded = true;
        });
      }, onAdFailedToLoad: (err) {
        log(err.toString());
        setState(() {
          isFullPageAdLoaded = false;
        });
      }),
    );
  }

  void _initBannerAd() {
    _bottomBannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => isBottomBannerAdLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
      request: const AdRequest(),
    );
    _bottomBannerAd.load();
  }
}
