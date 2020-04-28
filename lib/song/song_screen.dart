import 'dart:async';

import 'package:cantapp/extensions/string.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/favorite/favorite_icon_button.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/song_lyric.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/widgets/banner_ads.dart';
import 'package:cantapp/song/widgets/font_size_slider.dart';
import 'package:cantapp/song/widgets/lyric.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cantapp/song/servizi/servizi_screen.dart';

class SongScreen extends StatelessWidget {
  final Song _song;
  final EdgeInsets safeAreaChildScroll =
      const EdgeInsets.symmetric(horizontal: 25);

  const SongScreen({@required Song song}) : _song = song;

  @override
  Widget build(BuildContext context) {
    // var adsData = Provider.of<Ads>(context);
    // adsData.initState();

    // incrementa view della canzone
    // esegue funziona asincrona
    // _incrementViews(context);

    final database = Provider.of<FirestoreDatabase>(context,
        listen: false); // potrebbe essere true, da verificare

    var sessionTask = Future.delayed(Duration(seconds: 10))
        .asStream()
        .listen((res) => database.incrementView(_song.id));

    return Scaffold(
      body: Consumer<SongLyric>(
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
                    _buildServiziButton(context, lyricData),
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
                        text: _song.lyric, fontSize: lyricData.fontSize),
                  ),
                  SizedBox(height: 80),
                ]),
              ),
              SliverFixedExtentList(
                  delegate: SliverChildListDelegate.fixed([BannerAdsWidget()]),
                  itemExtent: 1)
            ],
          );
        },
      ),
    );
  }

  _buildServiziButton(BuildContext context, SongLyric lyricData) {
    if (_song.links.length > 0 || !_song.chord.isNullOrEmpty()) {
      return SizedBox(
        width: 80.00,
        height: 25.00,
        child: RaisedButton(
          child: Text(
            "servizi",
          ),
          color: lightBG,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
            side: BorderSide(color: Colors.black),
          ),
          onPressed: () {
            // adsData.hide();
            lyricData.isCollapsed = false;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ServiziScreen(song: _song)));
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
        .listen((res) => database.incrementView(_song.id));
  }
}
