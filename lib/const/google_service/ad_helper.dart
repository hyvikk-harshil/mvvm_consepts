import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6649638047463647/3686262396';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6649638047463647/3686262396';
    }
    throw UnsupportedError("Unsupported platform");
  }

  // static String get nativeAdUnitId {
  //   if (Platform.isAndroid) {
  //     return 'ca-app-pub-3940256099942544/2247696110';
  //   } else if (Platform.isIOS) {
  //     return 'ca-app-pub-3940256099942544/3986624511';
  //   }
  //   throw UnsupportedError("Unsupported platform");
  // }
}