import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FirestoreDatabase _firestoreDatabase;
  StreamSubscription _favoritesSubscription;
  StreamSubscription _favoriteExistSubscription;

  FavoriteBloc({@required FirestoreDatabase firestoreDatabase})
      : assert(firestoreDatabase != null),
        _firestoreDatabase = firestoreDatabase,
        super(FavoriteInitial());

  @override
  Stream<FavoriteState> mapEventToState(
    FavoriteEvent event,
  ) async* {
    if (event is FavoritesLoad) {
      yield* _mapLoadFavoritesToState();
    }
    if (event is UpdateFavorites) {
      yield* _mapUpdateFavorites(event);
    }
    if (event is AddFavorite) {
      yield* _mapAddFavoriteToState(event);
    }
    if (event is RemoveFavorite) {
      yield* _mapRemoveFavoriteToState(event);
    }
    if (event is RemoveFavoriteFromSong) {
      yield* _mapRemoveFavoriteFromSongToState(event);
    }
    if (event is FavoriteExist) {
      yield* _mapFavoriteExistToState(event);
    }
    if (event is FavoriteExistSuccess) {
      yield* _mapFavoriteExistSuccessToState(event);
    }
    if (event is FavoriteExistError) {
      yield* _mapFavoriteExistErrorToState(event);
    }
    if (event is UpdateAuthId) {
      yield* _mapUpdateAuthIdToState(event.authId);
    }
  }

  Stream<FavoriteState> _mapLoadFavoritesToState() async* {
    _favoritesSubscription?.cancel();
    _favoritesSubscription = _firestoreDatabase
        .favoritesStream()
        .listen((event) => add(UpdateFavorites(event)));
  }

  Stream<FavoriteState> _mapUpdateFavorites(UpdateFavorites event) async* {
    yield FavoriteLoaded(event.favorites);
  }

  Stream<FavoriteState> _mapAddFavoriteToState(AddFavorite event) async* {
    _firestoreDatabase.addFavorite(event.favorite);
  }

  Stream<FavoriteState> _mapRemoveFavoriteToState(RemoveFavorite event) async* {
    _firestoreDatabase.removeFavorite(event.favoriteId);
  }

  Stream<FavoriteState> _mapRemoveFavoriteFromSongToState(
      RemoveFavoriteFromSong event) async* {
    _firestoreDatabase.removeFavoriteFromSong(event.songId);
  }

  Stream<FavoriteState> _mapFavoriteExistToState(FavoriteExist event) async* {
    _favoriteExistSubscription?.cancel();
    _favoriteExistSubscription = _firestoreDatabase
        .favoriteIdFromSongStream(event.songId)
        .listen(
            (String favoriteId) =>
                add(FavoriteExistSuccess(favoriteId.isNotEmpty, favoriteId)),
            onError: () => add(FavoriteExistError("errore")));
  }

  Stream<FavoriteState> _mapFavoriteExistSuccessToState(
      FavoriteExistSuccess event) async* {
    yield FavoriteExistSuccessed(event.exist, event.favoriteId);
  }

  Stream<FavoriteState> _mapFavoriteExistErrorToState(
      FavoriteExistError event) async* {
    yield FavoriteExistErrored(event.message);
  }

  Stream<FavoriteState> _mapUpdateAuthIdToState(String authId) async* {
    _firestoreDatabase = FirestoreDatabase(uid: authId);
    add(FavoritesLoad());
  }

  Stream<String> favoriteIdFromSongStream(String songId) =>
      _firestoreDatabase.favoriteIdFromSongStream(songId);

  Stream<List<FavoriteFire>> favoritesStream() =>
      _firestoreDatabase.favoritesStream();
}
