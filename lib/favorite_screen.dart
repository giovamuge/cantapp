import 'package:cantapp/bloc_provider.dart';
import 'package:cantapp/favorite_bloc.dart';
import 'package:cantapp/list_songs_screen.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  FavoritesBloc _favoriteBloc;

  @override
  Widget build(BuildContext context) {
    _favoriteBloc = BlocProvider.favorites(context);
    return ListSongsScreen(
      songListData: _favoriteBloc.favorites,
      title: "Preferiti",
    );
  }
}
