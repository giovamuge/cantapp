import 'dart:async';

import 'package:cantapp/extensions/string.dart';
import 'package:cantapp/favorite/favorite_icon_button.dart';
import 'package:cantapp/services/firebase_ads_service.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/song_lyric.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/widgets/font_size_slider.dart';
import 'package:cantapp/song/widgets/lyric.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:cantapp/song/servizi/servizi_screen.dart';

class SongScreen extends StatelessWidget {
  final String _id;
  final EdgeInsets safeAreaChildScroll =
      const EdgeInsets.symmetric(horizontal: 25);

  const SongScreen({@required String id}) : _id = id;

  @override
  Widget build(BuildContext context) {
    // var adsData = Provider.of<Ads>(context);
    // adsData.initState();

    // incrementa view della canzone
    // esegue funziona asincrona
    // _incrementViews(context);

    // final database = Provider.of<FirestoreDatabase>(context,
    //     listen: false); // potrebbe essere true, da verificare

    var sessionTask = Future.delayed(Duration(seconds: 10))
        .asStream()
        .listen((res) => _incrementViewAsync());
    // .listen((res) => database.incrementView(_song.id));

    var service = new FirebaseAdsService();
    service.createBannerAd();

    final database = Provider.of<FirestoreDatabase>(context,
        listen: false); // potrebbe essere true, da verificare

    return Scaffold(
      body: StreamBuilder<Song>(
        stream: database.songStream(_id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final Song _song = snapshot.data;
            return Consumer<SongLyric>(
              builder: (context, lyricData, child) {
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      floating: true,
                      pinned: false,
                      snap: true,
                      leading: BackButton(
                        onPressed: () {
                          Future.microtask(() => sessionTask.cancel());
                          Navigator.pop(context);
                        },
                      ),
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          _buildServiziButton(context, lyricData, _song),
                        ],
                      ),
                      actions: <Widget>[
                        FavoriteIconButtonWidget(songId: _song.id),
                        IconButton(
                          icon: Icon(Icons.format_size),
                          onPressed: lyricData.collaspe,
                        ),
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        FontSizeSliderWidget(collasped: lyricData.isCollapsed),
                        SizedBox(height: 20),
                        Padding(
                          padding: safeAreaChildScroll,
                          child: Text(
                            _song.title,
                            style: TextStyle(
                                fontSize: lyricData.fontSize * 1.25,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: safeAreaChildScroll,
                          child: LyricWidget(
                            text: _song.lyric,
                            fontSize: lyricData.fontSize,
                            child: service.banner,
                          ),
                        ),
                        // Padding(
                        //   padding: safeAreaChildScroll,
                        //   child: service.banner,
                        // ),
                        SizedBox(height: 80),
                      ]),
                    ),
                    // SliverFixedExtentList(
                    //     delegate: SliverChildListDelegate.fixed([BannerAdsWidget()]),
                    //     itemExtent: 1)
                  ],
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _buildServiziButton(BuildContext context, SongLyric lyricData, Song song) {
    if (song.links.length > 0 || !song.chord.isNullOrEmpty()) {
      return SizedBox(
        width: 80.00,
        height: 25.00,
        child: RaisedButton(
          child: Text(
            "servizi",
            overflow: TextOverflow.ellipsis,
          ),
          color: Theme.of(context).backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
            side: BorderSide(color: Theme.of(context).primaryColor),
          ),
          onPressed: () {
            // adsData.hide();
            lyricData.isCollapsed = false;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ServiziScreen(song: song)));
          },
        ),
      );
    } else {
      return Container();
    }
  }

  void _incrementViews(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context,
        listen: false); // potrebbe essere true, da verificare

    Future.delayed(Duration(seconds: 5))
        .asStream()
        .listen((res) => database.incrementView(_id));
  }

  Future<void> _incrementViewAsync() async {
    final String url =
        'https://us-central1-mgc-cantapp.cloudfunctions.net/incrementView?songId=${_id}';
    final Response response = await put(url);
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print('song incremented corretly');
      return;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to increment views');
    }
  }
}
