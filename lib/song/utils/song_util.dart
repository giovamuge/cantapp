import 'package:admob_flutter/admob_flutter.dart';
import 'package:cantapp/services/firebase_ads_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../song_lyric.dart';

class SongUtil {
  const SongUtil();

  FutureBuilder<Widget> buildFutureBannerAd() {
    return FutureBuilder(
      future: FirebaseAdsService().createBannerAdAsync(),
      builder: (context, data) {
        if (data.hasData && data.data is Widget) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 20,
            ),
            child: data.data,
          );
        } else {
          return Container();
        }
      },
    );
  }

  // ignore: slash_for_doc_comments
  /**
   *  [onBannerCreatedCallback] Function(AdmobBannerController)
   *   Dispose is called automatically for you when Flutter removes the banner from the widget tree.
   *   Normally you don't need to worry about disposing this yourself, it's handled.
   *   If you need direct access to dispose, this is your guy!
   *   controller.dispose();
   *},
   */
  Widget buildBannerAd(
      Function(AdmobBannerController) onBannerCreatedCallback) {
    return AdmobBanner(
      adUnitId: FirebaseAdsService.getBannerAdUnitId(),
      adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        handleEvent(event, args, 'Banner');
      },
      onBannerCreated: onBannerCreatedCallback,
    );
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        print('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        print('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        print('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        print('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        print('New Admob $adType Ad rewarded!');
        break;
      default:
    }
  }

  Future<void> settingModalBottomSheet(context) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                color: Theme.of(context).dialogBackgroundColor,
                width: constraints.maxWidth,
                height: 200,
                child: Consumer<SongLyric>(
                  builder: (context, data, child) {
                    return Wrap(
                      // mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                            leading: Icon(Icons.text_fields, size: 30),
                            title: Text('Grande'),
                            trailing: data.fontSize >= 30
                                ? Icon(FontAwesomeIcons.check, size: 16)
                                : Text('imposta'),
                            onTap: () {
                              data.fontSize = 30;
                              Navigator.of(context).pop();
                            }),
                        ListTile(
                            leading: Icon(Icons.text_fields, size: 22.5),
                            title: Text('Normale'),
                            trailing: data.fontSize < 30 && data.fontSize > 15
                                ? Icon(FontAwesomeIcons.check, size: 16)
                                : Text('imposta'),
                            onTap: () {
                              data.fontSize = 22.5;
                              Navigator.of(context).pop();
                            }),
                        ListTile(
                            leading: Icon(Icons.text_fields, size: 15),
                            title: Text('Piccolo'),
                            trailing: data.fontSize <= 15
                                ? Icon(FontAwesomeIcons.check, size: 16)
                                : Text('imposta'),
                            onTap: () {
                              data.fontSize = 15;
                              Navigator.of(context).pop();
                            }),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
