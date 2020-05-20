import 'package:cantapp/services/firebase_ads_service.dart';
import 'package:flutter/material.dart';

class BannerAdsWidget extends StatefulWidget {
  @override
  _BannerAdsWidgetState createState() => _BannerAdsWidgetState();
}

class _BannerAdsWidgetState extends State<BannerAdsWidget> {
  FirebaseAdsService _service;

  @override
  void initState() {
    _service = new FirebaseAdsService();
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _service.createBannerAd());
  }
}