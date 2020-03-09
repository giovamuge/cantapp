import 'package:cantapp/favorite/heart.dart';
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
  Hearts _heartsData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _songsData = Provider.of<Songs>(context);
    _heartsData = Provider.of<Hearts>(context);
    await _songsData.fetchSongs();
  }

  @override
  Widget build(BuildContext context) {
    final hearts = _heartsData.items;
    final songs = _songsData.items;

    if (songs.length == 0 || hearts.length == 0) {
      return Center(
        child: Text("Non ci sono preferiti ❤️"),
      );
    }

    var songFavorite =
        songs.where((s) => hearts.any((f) => f == s.id)).toList();

    return ListSongsScreen(
      songListData: songFavorite,
      title: "Preferiti",
    );
  }

  @override
  void updateKeepAlive() {}

  @override
  bool get wantKeepAlive => true;
}
