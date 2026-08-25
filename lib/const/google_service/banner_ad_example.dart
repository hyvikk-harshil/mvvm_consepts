import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});
  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {

  // WARNING: Always use Google's official Test Ad IDs during development!
  final String _adUnitId = 'ca-app-pub-3940256099942544/6300978111';  ///Banner
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {
          ad.dispose(); // Always clear resources if load fails
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null) {
      return AdWidget(ad: _bannerAd!);
    }
    return SizedBox.shrink();// Hide if ad isn't ready
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}

