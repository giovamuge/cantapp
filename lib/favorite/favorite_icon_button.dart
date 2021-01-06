import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/services/firestore_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'bloc/favorite_bloc.dart';

class FavoriteIconButtonWidget extends StatelessWidget {
  final String songId;

  const FavoriteIconButtonWidget({@required this.songId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: BlocProvider.of<FavoriteBloc>(context)
          .favoriteIdFromSongStream(songId),
      builder: (context, state) {
        if (state.connectionState != ConnectionState.waiting) {
          final String favoriteId = state.data;
          final bool exist = state.hasData;
          return IconButton(
            icon: Icon(exist ? Icons.favorite : Icons.favorite_border),
            onPressed: () => exist
                ? BlocProvider.of<FavoriteBloc>(context)
                    .add(RemoveFavorite(favoriteId))
                : BlocProvider.of<FavoriteBloc>(context).add(
                    AddFavorite(
                      FavoriteFire(
                        songId: songId,
                        createdAt: DateTime.now(),
                        song: FirebaseFirestore.instance
                            .doc(FirestorePath.song(songId)),
                      ),
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
