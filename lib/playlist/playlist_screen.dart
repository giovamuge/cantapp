import 'package:cantapp/activity/activity_card.dart';
import 'package:flutter/material.dart';

import 'playlist.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen>
    with TickerProviderStateMixin {
  String _title;
  bool _visible = false;
  Animation _animation;
  AnimationController _animationController;
  ScrollController _controller;

  List<Playlist> _playlists = [
    Playlist(
        index: 0,
        title: "Popolari",
        color: Colors.orange,
        assetsImage: "icons/popularity.png"),
    Playlist(
        index: 1,
        title: "Novità",
        color: Colors.orange,
        assetsImage: "icons/new.png"),
    Playlist(
        index: 2,
        title: "Proposte",
        color: Colors.orange,
        assetsImage: "icons/plant_tree.png"),
  ];

  @override
  void initState() {
    print(_playlists);
    _visible = false;
    _title = "Playlist";
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _controller = new ScrollController();
    _controller.addListener(_onScrolling);
    super.initState();
  }

  void _onScrolling() {
    // valore di offset costante
    const offset = 40;
    // Mostra il bottone search quando raggiungo
    // 120 di altezza, dove si trovara il bottone
    // grande search.
    if (_controller.offset <= offset && _visible) {
      _visible = false;
      _animationController.reverse();
    }

    // Nascondi in caso contrario
    // Controllo su _visible per non ripete il set continuamente
    if (_controller.offset > offset && !_visible) {
      _visible = true;
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) =>
              Opacity(opacity: _animation.value, child: child),
          child: Text(_title),
        ),
      ),
      body: ListView(
        controller: _controller,
        padding: EdgeInsets.symmetric(horizontal: 20),
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              _title,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _playlists.length,
            itemBuilder: (context, i) => ActivityCardWidget(
              index: _playlists[i].index,
              color: _playlists[i].color,
              title: _playlists[i].title,
              assetsImage: _playlists[i].assetsImage,
              // itemBuilder: (context, i) => ListTile(
              //   title: Text(_playlists[i].title),
            ),
          )
        ],
      ),
    );
  }
}
