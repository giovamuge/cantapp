import 'package:cantapp/song/song_lyric.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/utils/song_util.dart';
import 'package:cantapp/song/widgets/font_size_slider.dart';
import 'package:cantapp/song/widgets/lyric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../song_full_screen.dart';

class ChordScreen extends StatefulWidget {
  final Song _song;
  const ChordScreen({@required Song song}) : _song = song;

  @override
  _ChordScreenState createState() => _ChordScreenState();
}

class _ChordScreenState extends State<ChordScreen> {
  EdgeInsets safeAreaChildScroll = const EdgeInsets.symmetric(horizontal: 25);

  @override
  Widget build(BuildContext context) {
    final SongLyric lyricData = Provider.of<SongLyric>(context);
    final SongUtil songUtil = SongUtil();

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: false,
            snap: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.fullscreen),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SongFullScreen(
                          body: widget._song.chord,
                          title: widget._song.title,
                          child: songUtil.buildFutureBannerAd(),
                        ),
                    fullscreenDialog: true)),
              ),
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
                  widget._song.title,
                  style: TextStyle(
                      fontSize: lyricData.fontSize * 1.25,
                      fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: safeAreaChildScroll,
                child: LyricWidget(
                  text: widget._song.chord,
                  fontSize: lyricData.fontSize,
                  child: songUtil.buildFutureBannerAd(),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
