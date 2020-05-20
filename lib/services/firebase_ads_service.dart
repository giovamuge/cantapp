import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';

class FirebaseAdsService {
  // final FirebaseAdMob _firebaseAd = FirebaseAdMob.instance;
  initialaze() {
    // _firebaseAd.initialize(appId: getAppId(), analyticsEnabled: true);
    Admob.initialize(getAppId());
  }

  static String getAppId() => Platform.isIOS
      ? "ca-app-pub-8102760961562906~1178455079"
      : (Platform.isAndroid ? "ca-app-pub-8102760961562906~3548826910" : null);

  static String getBannerAdUnitId() => Platform.isIOS
      ? "ca-app-pub-8102760961562906/3879999400"
      : (Platform.isAndroid ? "ca-app-pub-8102760961562906/6123073268" : null);

  // MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  //   keywords: <String>['flutterio', 'beautiful apps'],
  //   contentUrl: 'https://flutter.io',
  //   childDirected: false,
  //   testDevices: <String>[], // Android emulators are considered test devices
  // );

  AdmobBanner banner;

  createBannerAd() {
    // return BannerAd(
    //   adUnitId: getBannerAdUnitId(),
    //   size: AdSize.banner,
    //   targetingInfo: targetingInfo,
    //   listener: (MobileAdEvent event) {
    //     print("BannerAd event $event");
    //   },
    // );

    banner = AdmobBanner(
      adUnitId: getBannerAdUnitId(),
      adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
      listener: (event, listner) {
        print("BannerAd event $event");
      },
    );
  }
}
