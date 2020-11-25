import 'package:cantapp/services/firebase_ads_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../song_lyric.dart';

class SongUtil {
  const SongUtil();

  FutureBuilder<Widget> buildFutureBannerAd() {
    return FutureBuilder(
      future: GetIt.instance<FirebaseAdsService>().createBannerAdAsync(),
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
