import 'package:cantapp/common/theme.dart';
import 'package:cantapp/favorite/favorite_icon_button.dart';
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

  EdgeInsets safeAreaChildScroll = const EdgeInsets.symmetric(horizontal: 25);

  SongScreen({@required Song song}) : _song = song;

  @override
  Widget build(BuildContext context) {
    var lyricData = Provider.of<SongLyric>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: false,
            snap: true,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(
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
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ServiziScreen(song: _song))),
                  ),
                ),
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
              FontSizeSliderWidget(collasped: lyricData.isCollasped),
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
      ),
    );
  }
}
