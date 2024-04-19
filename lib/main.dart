import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'presentation/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //TODO:4 Add this line
  MobileAds.instance.initialize();
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
