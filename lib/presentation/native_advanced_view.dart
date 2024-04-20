import 'package:flutter/material.dart';
import 'package:google_admob/core/utils/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdvancedView extends StatefulWidget {
  const NativeAdvancedView({super.key});

  @override
  State<NativeAdvancedView> createState() => _NativeAdvancedViewState();
}

class _NativeAdvancedViewState extends State<NativeAdvancedView> {
  late NativeAd _nativeAd;
  bool isNativeLoad = false;

  @override
  void initState() {
    super.initState();
    nativeAdLoad();
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd.dispose();
  }

  void nativeAdLoad() {
    _nativeAd = NativeAd(
        adUnitId: AdHelper.nativeAdvancedAdUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            setState(() {
              print("$ad load");
              isNativeLoad = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            setState(() {
              print("$error load");
              isNativeLoad = true;
            });
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
            NativeTemplateStyle(templateType: TemplateType.small));
    _nativeAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Text('Native ads'),
            isNativeLoad
                ? Container(
                    color: Colors.grey,
                    height: 100,
                    child: AdWidget(ad: _nativeAd))
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
