import 'package:cantapp/services/firebase_ads_service.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class BannerAdsWidget extends StatefulWidget {
  @override
  _BannerAdsWidgetState createState() => _BannerAdsWidgetState();
}

class _BannerAdsWidgetState extends State<BannerAdsWidget> {
  BannerAd _bannerAd;

  @override
  void initState() {
    _bannerAd = FirebaseAdsService().createBannerAd()
      ..load()
      ..show();

    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
