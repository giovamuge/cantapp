import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

class FirebaseAdsService {
  // final FirebaseAdMob _firebaseAd = FirebaseAdMob.instance;
  initialaze() {
    // _firebaseAd.initialize(appId: getAppId(), analyticsEnabled: true);
    Admob.requestTrackingAuthorization().then((value) => Admob.initialize());
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

  AdmobBanner createBannerAd() {
    return AdmobBanner(
      adUnitId: getBannerAdUnitId(),
      adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
      listener: (event, listner) {
        print("BannerAd event $event");
      },
    );
  }

  Future<Widget> createBannerAdAsync() async {
    return Future(() {
      // return Container();
      return AdmobBanner(
        adUnitId: getBannerAdUnitId(),
        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
        listener: (event, listner) {
          print("BannerAd event $event");
        },
      );
    });
  }
}
