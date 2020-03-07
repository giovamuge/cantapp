import 'package:cantapp/bloc_provider.dart';
import 'package:cantapp/favorite/favorite_bloc.dart';
import 'package:cantapp/widgets/list_songs_screen.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    implements AutomaticKeepAliveClientMixin<FavoriteScreen> {
  FavoritesBloc _favoriteBloc;

  @override
  Widget build(BuildContext context) {
    _favoriteBloc = BlocProvider.favorites(context);
    return ListSongsScreen(
      songListData: _favoriteBloc.favorites,
      title: "Preferiti",
    );
  }

  @override
  void updateKeepAlive() {}

  @override
  bool get wantKeepAlive => true;
}