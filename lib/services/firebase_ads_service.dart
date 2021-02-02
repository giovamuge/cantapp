import 'dart:io';

class FirebaseAdsService {
  // final FirebaseAdMob _firebaseAd = FirebaseAdMob.instance;
  initialaze() {
    // _firebaseAd.initialize(appId: getAppId(), analyticsEnabled: true);
    // Admob.requestTrackingAuthorization().then((value) => Admob.initialize());
  }

  static String getAppId() => Platform.isIOS
      ? "ca-app-pub-8102760961562906~1178455079"
      : (Platform.isAndroid ? "ca-app-pub-8102760961562906~3548826910" : null);

  static String getBannerAdUnitId() => Platform.isIOS
      ? "ca-app-pub-8102760961562906/3879999400"
      : (Platform.isAndroid ? "ca-app-pub-8102760961562906/6123073268" : null);

  static String interstitialAdUnitId() => Platform.isIOS
      ? "ca-app-pub-8102760961562906/3891234274"
      : (Platform.isAndroid ? "ca-app-pub-8102760961562906/5012744259" : null);

  // MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  //   keywords: <String>['flutterio', 'beautiful apps'],
  //   contentUrl: 'https://flutter.io',
  //   childDirected: false,
  //   testDevices: <String>[], // Android emulators are considered test devices
  // );

  // AdmobBanner createBannerAd() {
  //   return AdmobBanner(
  //     adUnitId: getBannerAdUnitId(),
  //     adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
  //     listener: (event, listner) {
  //       print("BannerAd event $event");
  //     },
  //   );
  // }

  // Future<Widget> createBannerAdAsync() async {
  //   return Future(() {
  //     // return Container();
  //     return AdmobBanner(
  //       adUnitId: getBannerAdUnitId(),
  //       adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
  //       listener: (event, listner) {
  //         print("BannerAd event $event");
  //       },
  //     );
  //   });
  // }
}

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8102760961562906~3548826910";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8102760961562906~1178455079";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8102760961562906/6123073268";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8102760961562906/3879999400";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8102760961562906/5012744259";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8102760961562906/3891234274";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
