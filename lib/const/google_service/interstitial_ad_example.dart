import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdExample extends StatefulWidget {
  const InterstitialAdExample({super.key});

  @override
  State<InterstitialAdExample> createState() => _InterstitialAdExampleState();
}

class _InterstitialAdExampleState extends State<InterstitialAdExample> {
  final String _interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';    ///Interstitial(fullscreen Ad)
  InterstitialAd? _interstitialAd;
  bool _isAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdReady = true;

          // Handle ad closure or failures after showing
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitialAd(); // Load the next ad immediately
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          _isAdReady = false;
        },
      ),
    );
  }
  void _showInterstitialAd() {
    if (_isAdReady && _interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      print('Ad is not ready yet.');
    }
  }

  @override
  Widget build(BuildContext context) {
      return ElevatedButton(
            onPressed: (){
              _showInterstitialAd();
            },
            child: Text("Interstitial AD")
        );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();// Always dispose ads to avoid memory leaks
    super.dispose();
  }
}
