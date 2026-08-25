import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdExample extends StatefulWidget {
  const RewardedAdExample({super.key});

  @override
  State<RewardedAdExample> createState() => _RewardedAdExampleState();
}

class _RewardedAdExampleState extends State<RewardedAdExample> {
  RewardedAd? _rewardedAd;
  bool _isAdReady = false;
  int _userCoins = 0;

  // Official Google Rewarded Test ID
  final String _adUnitId = 'ca-app-pub-3940256099942544/5224354917';

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isAdReady = true;

          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadRewardedAd(); // Load the next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
          _isAdReady = false;
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_isAdReady && _rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          // Reward the user here!
          setState(() {
            _userCoins += reward.amount.toInt();
          });
          print('User rewarded with: ${reward.amount} ${reward.type}');
        },
      );
    } else {
      print('Rewarded ad not ready yet.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Coins: $_userCoins', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showRewardedAd,
              child: const Text('Watch Video for Coins'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }
}
