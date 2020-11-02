import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/services/firestore_path.dart';
import 'package:cantapp/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class FavoriteIconButtonWidget extends StatelessWidget {
  final String songId;

  const FavoriteIconButtonWidget({@required this.songId});

  @override
  Widget build(BuildContext context) {
    final firestore = GetIt.instance<FirestoreDatabase>();
    return StreamBuilder<FavoriteFire>(
      stream: firestore.favoriteStream(songId),
      builder: (context, data) {
        return IconButton(
          icon: Icon(data.hasData ? Icons.favorite : Icons.favorite_border),
          onPressed: () => data.hasData
              ? firestore.removeFavorite(songId)
              : firestore.addFavorite(
                  FavoriteFire(
                    song:
                        Firestore.instance.document(FirestorePath.song(songId)),
                  ),
                ),
        );
      },
    );
  }
}
