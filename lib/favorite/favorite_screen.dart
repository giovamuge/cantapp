import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/widgets/list_songs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    implements AutomaticKeepAliveClientMixin<FavoriteScreen> {
  Songs _songsData;
  Favorites _favoritesData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    _songsData = Provider.of<Songs>(context);
    _favoritesData = Provider.of<Favorites>(context);

    await _songsData.fetchSongs();
    await _favoritesData.fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = _favoritesData.items;
    final songs = _songsData.items;

    if (songs.length == 0 || favorites.length == 0) {
      return Center(
        child: Text("Non ci sono preferiti ❤️"),
      );
    }

    var songFavorite =
        songs.where((s) => favorites.any((f) => f == s.id)).toList();

    return ListSongsScreen(
      // items: songFavorite, // todo: da implementare
      items: [],
      title: "Preferiti",
    );
  }

  @override
  void dispose() {
    // _songsData.dispose();
    // _favoritesData.dispose();
    super.dispose();
  }

  @override
  void updateKeepAlive() {}

  @override
  bool get wantKeepAlive => true;
}
