import 'package:flutter/material.dart';
import 'package:google_admob/core/utils/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../data/news_article.dart';
import 'news_article_page.dart';
import 'widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //TODO:6 Create these two variables for banner ad
  late BannerAd _bottomBannerAd;
  bool isBottomBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    //TODO:7 Initialize Banner Ad
    _initBannerAd();
  }

  @override
  void dispose() {
    //TODO:8 Dispose Banner Ad
    _bottomBannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle(),
        backgroundColor: Colors.indigo[800],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: NewsArticle.articles.length,
        itemBuilder: (context, index) {
          final article = NewsArticle.articles[index];
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NewsArticlePage(
                      title: article.headline,
                      imagePath: article.asset,
                    ),
                  ),
                );
              },
              child: ArticleTile(article: article),
            ),
          );
        },
      ),

      //TODO:9 Display Banner Ad
      persistentFooterButtons: [
        isBottomBannerAdLoaded
            ? Align(
                alignment: Alignment.center,
                child: Container(
                  color: Colors.red,
                  width: _bottomBannerAd.size.width.toDouble(),
                  height: _bottomBannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bottomBannerAd),
                ),
              )
            : const SizedBox.shrink()
      ],

      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
        BottomNavigationBarItem(
            label: 'Search', icon: Icon(Icons.search_outlined)),
        BottomNavigationBarItem(
            label: 'Profile', icon: Icon(Icons.person_2_outlined)),
      ]),
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
