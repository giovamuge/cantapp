import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class FirebaseAdsService {
  final FirebaseAdMob _firebaseAd = FirebaseAdMob.instance;

  initialaze() {
    _firebaseAd.initialize(appId: getAppId(), analyticsEnabled: true);
  }

  static String getAppId() => Platform.isIOS
      ? "ca-app-pub-8102760961562906~1178455079"
      : (Platform.isAndroid ? "ca-app-pub-8102760961562906~3548826910" : null);

  static String getBannerAdUnitId() => Platform.isIOS
      ? "ca-app-pub-8102760961562906/3879999400"
      : (Platform.isAndroid ? "ca-app-pub-8102760961562906/6123073268" : null);

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: getBannerAdUnitId(),
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }
}