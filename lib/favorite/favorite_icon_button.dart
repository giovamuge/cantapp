import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/services/firestore_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class FavoriteIconButtonWidget extends StatelessWidget {
  final String songId;

  const FavoriteIconButtonWidget({@required this.songId});

  @override
  Widget build(BuildContext context) {
    final firestore = GetIt.instance<FirestoreDatabase>();
    return StreamBuilder<String>(
      stream: firestore.favoriteIdFromSongStram(songId),
      builder: (context, data) {
        if (data.connectionState != ConnectionState.waiting) {
          final String favoriteId = data.data;
          final bool exist = favoriteId != null;
          return IconButton(
            icon: Icon(exist ? Icons.favorite : Icons.favorite_border),
            onPressed: () => exist
                ? firestore.removeFavorite(favoriteId)
                : firestore.addFavorite(
                    FavoriteFire(
                      song: Firestore.instance
                          .document(FirestorePath.song(songId)),
                    ),
                  ),
          );
        } else {
          return IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.grey),
              onPressed: null);
        }
      },
    );
  }
}
