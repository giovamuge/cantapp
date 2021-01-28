import 'dart:async';

import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/extensions/string.dart';
import 'package:cantapp/favorite/favorite_icon_button.dart';
import 'package:cantapp/responsive/screen_type_layout.dart';
import 'package:cantapp/song/bloc/song_bloc.dart';
import 'package:cantapp/song/song_lyric.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/utils/song_util.dart';
import 'package:cantapp/song/widgets/font_size_slider.dart';
import 'package:cantapp/song/widgets/lyric.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:cantapp/song/servizi/servizi_screen.dart';
import 'package:shimmer/shimmer.dart';

import 'song_full_screen.dart';

class SongScreen extends StatefulWidget {
  final String id;

  const SongScreen({@required this.id});

  @override
  _SongScreenState createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  final EdgeInsets safeAreaChildScroll =
      const EdgeInsets.symmetric(horizontal: 25);

  StreamSubscription<dynamic> _sessionTask;
  SongUtil _songUtil;

  @override
  void initState() {
    // call event to fetcg song in song_bloc
    BlocProvider.of<SongBloc>(context).add(SongFetched(widget.id));

    _songUtil = SongUtil();
    _sessionTask = Future.delayed(Duration(seconds: 10))
        .asStream()
        .listen((res) => _incrementViews());

    super.initState();
  }

  @override
  void dispose() {
    _sessionTask.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      body: FutureBuilder<Song>(
        // possibile sostituzione in future perché viene rebuild
        // quando inserisco una nuova visualizzazione in più
        future: BlocProvider.of<SongBloc>(context).fetchSong(widget.id),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasData &&
              asyncSnapshot.connectionState != ConnectionState.waiting) {
            Song song = asyncSnapshot.data;
            if (song == null) {
              return Center(
                child: Text("Errore nel caricamento."),
              );
            } else {
              return Consumer<SongLyric>(
                builder: (context, lyricData, child) {
                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        floating: true,
                        pinned: false,
                        snap: true,
                        leading: ScreenTypeLayout(
                          mobile: BackButton(
                            onPressed: () {
                              // Future.microtask(() => sessionTask.cancel());
                              Navigator.pop(context);
                            },
                          ),
                          tablet: Container(),
                        ),
                        title: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            _buildServiziButton(context, lyricData, song),
                          ],
                        ),
                        actions: <Widget>[
                          // todo: da riabilitare
                          IconButton(
                              icon: Icon(Icons.fullscreen),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SongFullScreen(
                                      body: song.lyric,
                                      title: song.title,
                                      child: _songUtil.buildFutureBannerAd(),
                                    ),
                                    fullscreenDialog: true,
                                  ),
                                );
                              }),
                          FavoriteIconButtonWidget(songId: song.id),
                          IconButton(
                            icon: Icon(Icons.format_size),
                            onPressed: lyricData.collaspe,
                          ),
                        ],
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          FontSizeSliderWidget(
                            collasped: lyricData.isCollapsed,
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: safeAreaChildScroll,
                            child: Text(
                              song.title,
                              style: TextStyle(
                                fontSize: lyricData.fontSize * 1.25,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: safeAreaChildScroll,
                            child: LyricWidget(
                              text: song.lyric,
                              fontSize: lyricData.fontSize,
                              child: _songUtil.buildFutureBannerAd(),
                            ),
                          ),
                          // Padding(
                          //   padding: safeAreaChildScroll,
                          //   child: service.banner,
                          // ),
                          SizedBox(height: 80),
                        ]),
                      ),
                    ],
                  );
                },
              );
            }
          } else {
            final theme = Provider.of<ThemeChanger>(context, listen: false);
            final double sizeHeight = MediaQuery.of(context).size.height;
            final double titleHeight = sizeHeight * 0.10;
            final double subtitleHeight = sizeHeight * 0.05;
            final double bodyHeight = sizeHeight * 0.80;

            return Shimmer.fromColors(
              // baseColor: Theme.of(context).primaryColorLight,
              // highlightColor: Theme.of(context).primaryColor,
              baseColor: theme.getThemeName() == Constants.themeLight
                  ? Colors.grey[100]
                  : Colors.grey[600],
              highlightColor: theme.getThemeName() == Constants.themeLight
                  ? Colors.grey[300]
                  : Colors.grey[900],
              child: SafeArea(
                child: ListView(
                  // mainAxisSize: MainAxisSize.max,
                  padding: const EdgeInsets.all(20),
                  // physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      height: titleHeight,
                      width: MediaQuery.of(context).size.width * .5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: subtitleHeight,
                      width: MediaQuery.of(context).size.width * .25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: bodyHeight,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ); // da sostituire con shimmer
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ServiziScreen(song: song),
              ),
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }

  void _incrementViews() =>
      BlocProvider.of<SongBloc>(context).add(SongViewIncremented(widget.id));
}
