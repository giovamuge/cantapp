import 'dart:async';

import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/common/utils.dart';
import 'package:cantapp/favorite/favorite_icon_button.dart';
import 'package:cantapp/responsive/screen_type_layout.dart';
import 'package:cantapp/song/bloc/song_bloc.dart';
import 'package:cantapp/services/firebase_ads_service.dart';
import 'package:cantapp/song/song_lyric.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/widgets/font_size_slider.dart';
import 'package:cantapp/song/widgets/header_lyric.dart';
import 'package:cantapp/song/widgets/lyric.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'servizi/chord_screen.dart';
import 'servizi/youtube_card.dart';
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
  PageController _controller;
  BannerAd _bannerAd;

  void _loadBannerAd() {
    _bannerAd.load();
  }

  @override
  void initState() {
    final theme = Provider.of<ThemeChanger>(context, listen: false);
    if (theme.getThemeName() == Constants.themeLight) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }

    // call event to fetcg song in song_bloc
    BlocProvider.of<SongBloc>(context).add(SongFetched(widget.id));

    _controller = PageController(initialPage: 0, viewportFraction: .9);
    _sessionTask = Future.delayed(Duration(seconds: 10))
        .asStream()
        .listen((res) => _incrementViews());

    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.mediumRectangle,
      listener: AdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an ad is in the process of leaving the application.
        onApplicationExit: (Ad ad) => print('Left application.'),
      ),
    );

    _loadBannerAd();

    super.initState();
  }

  @override
  void dispose() {
    _sessionTask?.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<Song>(
          // possibile sostituzione in future perché viene rebuild
          // quando inserisco una nuova visualizzazione in più
          future: BlocProvider.of<SongBloc>(context).fetchSong(widget.id),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData &&
                asyncSnapshot.connectionState != ConnectionState.waiting) {
              Song song = asyncSnapshot.data;

              final List<Link> videos =
                  song.links.where((l) => l.type == 'youtube').toList();
              final List<Link> audios =
                  song.links.where((l) => l.type == 'audio').toList();

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
                          // title: Row(
                          //   mainAxisSize: MainAxisSize.max,
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: <Widget>[
                          //     _buildServiziButton(context, lyricData, song),
                          //   ],
                          // ),
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
                                        number: song.number,
                                        artist: song.artist,
                                        categories: song.categories,
                                        child: Container(),
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
                          delegate: SliverChildListDelegate(
                            [
                              FontSizeSliderWidget(
                                collasped: lyricData.isCollapsed,
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: safeAreaChildScroll,
                                child: HeaderLyric(
                                  title: song.title,
                                  number: song.number,
                                  artist: song.artist,
                                  categories: song.categories,
                                ),
                              ),
                              SizedBox(height: 25),
                              Padding(
                                padding: safeAreaChildScroll,
                                child: LyricWidget(
                                  text: song.lyric,
                                  fontSize: lyricData.fontSize,
                                  child: Container(),
                                ),
                              ),
                              Padding(
                                padding: safeAreaChildScroll,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: AdWidget(ad: _bannerAd),
                                  width: _bannerAd.size.width.toDouble(),
                                  height: _bannerAd.size.height.toDouble(),
                                ),
                              ),
                              SizedBox(height: 30),
                              Padding(
                                padding: safeAreaChildScroll,
                                child: Text(
                                  "Accordi",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .fontSize),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: _buildListChords(song),
                              ),
                              if (videos.isNotEmpty) SizedBox(height: 30),
                              if (videos.isNotEmpty)
                                Padding(
                                  padding: safeAreaChildScroll,
                                  child: Container(
                                    // height: 90,
                                    child: Column(
                                      // scrollDirection: Axis.horizontal,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ..._buildVideos(videos),
                                      ],
                                    ),
                                  ),
                                ),
                              if (audios.isNotEmpty) SizedBox(height: 10),
                              if (audios.isNotEmpty) ..._buildAudios(audios),
                              SizedBox(height: 100.00)
                            ],
                          ),
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
      ),
    );
  }

  // todo: da cancellare
  // Widget _buildServiziButton(
  //     BuildContext context, SongLyric lyricData, Song song) {
  //   if (song.links.length > 0 || !song.chord.isNullOrEmpty()) {
  //     return SizedBox(
  //       width: 80.00,
  //       height: 25.00,
  //       child: ElevatedButton(
  //         child: Text(
  //           "servizi",
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //         // color: Theme.of(context).backgroundColor,
  //         // elevation: 0,
  //         // shape: RoundedRectangleBorder(
  //         //   borderRadius: BorderRadius.circular(2),
  //         //   side: BorderSide(color: Theme.of(context).primaryColor),
  //         // ),
  //         onPressed: () {
  //           // adsData.hide();
  //           lyricData.isCollapsed = false;
  //           Navigator.of(context).push(
  //             MaterialPageRoute(
  //               builder: (context) => ServiziScreen(song: song),
  //             ),
  //           );
  //         },
  //       ),
  //     );
  //   } else {
  //     return Container();
  //   }
  // }

  List<Widget> _buildVideos(List<Link> videos) {
    if (videos.length > 0) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "YouTube",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.headline6.fontSize),
              )
              // FlatButton(
              //   child: Text("visualizza tutto"),
              //   textColor: Colors.yellow,
              //   padding: const EdgeInsets.all(0),
              //   onPressed: () {},
              // )
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 300.00,
          child: PageView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            // onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: videos.length,
            itemBuilder: (ctx, index) =>
                YouTubeCard(heigth: 300.00, url: videos[index].url),
          ),
        ),
      ];
    } else {
      return [Container()];
    }
  }

  List<Widget> _buildAudios(List<Link> audios) {
    if (audios.length > 0) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Audio mp3",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // FlatButton(
              //   child: Text("visualizza tutto"),
              //   textColor: Colors.yellow,
              //   padding: const EdgeInsets.all(0),
              //   onPressed: () {},
              // )
            ],
          ),
        ),
        // SizedBox(height: 10),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              final double cardHeigth = 200;
              final double cardWidth = 150;

              final double titleHeigth = cardHeigth * 66 / 100;
              final double subHeight = cardHeigth * 34 / 100;

              final double paddingLeft = (index == 0) ? 20.00 : 5.00;

              return Padding(
                padding: EdgeInsets.only(left: paddingLeft, right: 5),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => Utils.launchURL(
                      'https://www.youtube.com/watch?v=CReCKHj8GTk'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Column(children: [
                      Container(
                        width: cardWidth,
                        height: titleHeigth,
                        color: Colors.yellow,
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.headphones,
                            color: Colors.white,
                            size: 50.00,
                          ),
                        ),
                      ),
                      Container(
                        width: cardWidth,
                        height: subHeight,
                        color: Colors.white,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                            "MOSCA in 40ena e l'INCIDENTE DIPLOMATICO RUSSIA-ITALIA"),
                      )
                    ]),
                  ),
                ),
              );
            },
          ),
        ),
      ];
    } else {
      return [Container()];
    }
  }

  Widget _buildListChords(song) {
    if (song == null || song.chord == null) {
      return Container(
        padding: const EdgeInsets.only(left: 20),
        child: Text("Non ci sono accordi"),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 1,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ChordScreen(song: song))),
          title: Text("Versione 1"),
          leading: CircleAvatar(
            maxRadius: 20,
            backgroundColor: Colors.purple[100],
            child: Text(
              '1',
              style: TextStyle(
                  color: Colors.purple[900],
                  fontWeight: FontWeight.w800,
                  fontSize: 11),
            ),
          ),
        );
      },
    );
  }

  void _incrementViews() =>
      BlocProvider.of<SongBloc>(context).add(SongViewIncremented(widget.id));
}
