# mvvm_consepts

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Here is the breakdown of every AdMob format, what they are, and why we use them.
1. Banner AdsSmall, rectangular ads that sit at the top or bottom of the screen.Why we use them: They stay on screen while the user interacts with the app. They are great for constant, low-intrusive revenue.Best for: Utility apps, news feeds, or persistent screens.Flutter Implementation:dartBannerAd(
adUnitId: 'YOUR_AD_UNIT_ID',
size: AdSize.banner,
request: const AdRequest(),
listener: BannerAdListener(
onAdLoaded: (ad) => print('Banner loaded.'),
onAdFailedToLoad: (ad, error) => ad.dispose(),
),
)..load();
Use code with caution.2. Interstitial AdsFull-screen ads that cover the entire interface of the app.Why we use them: High visibility means much higher earnings than banners. They appear during natural breaks in the app flow.Best for: Between game levels, after completing a task, or when switching tabs.Flutter Implementation:dartInterstitialAd.load(
adUnitId: 'YOUR_AD_UNIT_ID',
request: const AdRequest(),
adLoadCallback: InterstitialAdLoadCallback(
onAdLoaded: (ad) {
ad.show(); // Show when ready
},
onAdFailedToLoad: (error) => print('Failed: $error'),
),
);
Use code with caution.3. Rewarded AdsFull-screen video ads where users voluntarily watch an ad to get a reward.Why we use them: They have the highest payouts. Users love them because they get free premium perks without spending real money.Best for: Unlocking a game life, getting extra coins, or viewing premium articles.Flutter Implementation:dartRewardedAd.load(
adUnitId: 'YOUR_AD_UNIT_ID',
request: const AdRequest(),
rewardedAdLoadCallback: RewardedAdLoadCallback(
onAdLoaded: (ad) {
ad.show(onUserEarnedReward: (adWithoutView, reward) {
print('User earned: ${reward.amount} ${reward.type}');
});
},
onAdFailedToLoad: (error) => print('Failed: $error'),
),
);
Use code with caution.4. Rewarded Interstitial AdsA hybrid format that spins up a full-screen ad naturally, but offers a reward at the end. Unlike normal rewarded ads, the user doesn't have to opt-in first.Why we use them: It balances a seamless app flow with high reward-style payouts.Best for: Natural pauses where you want to surprise users with a bonus.5. Native AdsComponent-based ads that you can style with Flutter widgets to look like part of your app.Why we use them: They do not look like standard ads. They match your app's fonts, colors, and layout perfectly, leading to better user experiences.Best for: Inside scrollable lists, social media feeds, or custom dashboards.6. App Open AdsAds that show up immediately when the user opens or switches back to your app.Why we use them: Monetises the very first action a user takes before they even see your content.Best for: Splash screens or loading sequences.