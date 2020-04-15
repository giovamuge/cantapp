import 'package:cantapp/favorite/favorite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteIconButtonWidget extends StatelessWidget {
  final String songId;

  const FavoriteIconButtonWidget({@required this.songId});

  @override
  Widget build(BuildContext context) {
    return Consumer<Favorites>(
      builder: (context, favorites, child) {
        return IconButton(
          icon: Icon(
              favorites.exist(songId) ? Icons.favorite : Icons.favorite_border),
          onPressed: () => favorites.exist(songId)
              ? favorites.removeFavorite(songId)
              : favorites.addFavorite(songId),
        );
      },
    );
  }
}
