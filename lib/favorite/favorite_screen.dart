import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/song_item.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with TickerProviderStateMixin
    implements AutomaticKeepAliveClientMixin<FavoriteScreen> {
  String _title;
  bool _visible = false;
  Animation _animation;
  AnimationController _animationController;
  ScrollController _controller;

  @override
  void initState() {
    _visible = false;
    _title = "Preferiti";
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _controller = new ScrollController();
    _controller.addListener(_onScrolling);
    super.initState();
  }

  @override
  void dispose() {
    _animation = null;
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
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
          _buildContents(context),
        ],
      ),
    );
  }

  _buildContents(BuildContext context) {
    final firestore = GetIt.instance<FirestoreDatabase>();
    return StreamBuilder<List<FavoriteFire>>(
      stream: firestore.favoritesStream(),
      builder: (ctx, data) {
        if (data.hasData) {
          final favorites = data.data;

          if (favorites.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: favorites.length,
              itemBuilder: (ctx, i) {
                final songs = favorites[i];
                return FutureBuilder(
                  future: songs.song.get(),
                  builder: (ctx, data2) {
                    if (data2.hasData) {
                      final DocumentSnapshot songMapData = data2.data;
                      if (songMapData.exists) {
                        final SongLight song = SongLight.fromMap(
                            songMapData.data, songMapData.documentID);
                        return SongWidget(song: song);
                      } else {
                        return Container(
                          height: 300,
                          child: Center(
                            child: Text("La canzone non è più presente 🙅‍♂️"),
                          ),
                        );
                      }
                    } else {
                      return ListTile(
                        leading: Container(
                          width: 35.00,
                          height: 35.00,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white,
                          ),
                        ),
                        title: Container(
                          width: double.infinity,
                          height: 30.00,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          } else {
            return Container(
              height: 300,
              child: Center(
                child: Text("Non ci sono preferiti 🤷‍♂️"),
              ),
            );
          }
        }

        // return Container();
        final theme = Provider.of<ThemeChanger>(context, listen: false);
        final sizeWidth = MediaQuery.of(context).size.width;

        return Shimmer.fromColors(
          // baseColor: Theme.of(context).primaryColorLight,
          // highlightColor: Theme.of(context).primaryColor,
          baseColor: theme.getThemeName() == Constants.themeLight
              ? Colors.grey[100]
              : Colors.grey[600],
          highlightColor: theme.getThemeName() == Constants.themeLight
              ? Colors.grey[300]
              : Colors.grey[900],
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Container(
                  width: 35.00,
                  height: 35.00,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.white,
                  ),
                ),
                title: Container(
                  width: sizeWidth - 35.00,
                  height: 30.00,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.white,
                  ),
                ),
              );
            },
            itemCount: List.generate(10, (i) => i++).length,
          ),
        );
      },
    );
  }

  @override
  void updateKeepAlive() {}

  @override
  bool get wantKeepAlive => true;
}
