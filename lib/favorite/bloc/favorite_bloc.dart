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
        super(FavoriteInitial()) {
    on<FavoritesLoad>(_onLoadFavorites);
    on<UpdateFavorites>(_onUpdateFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
    on<RemoveFavoriteFromSong>(_onRemoveFavoriteFromSong);
    on<FavoriteExist>(_onFavoriteExist);
    on<FavoriteExistSuccess>(_onFavoriteExistSuccess);
    on<FavoriteExistError>(_onFavoriteExistError);
    on<UpdateAuthId>(_onUpdateAuthId);
  }

  FutureOr<void> _onLoadFavorites(
      FavoritesLoad event, Emitter<FavoriteState> emit) async {
    _favoritesSubscription?.cancel();
    _favoritesSubscription = _firestoreDatabase
        .favoritesStream()
        .listen((event) => add(UpdateFavorites(event)));
  }

  FutureOr<void> _onUpdateFavorites(
      UpdateFavorites event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoaded(event.favorites));
  }

  FutureOr<void> _onAddFavorite(
      AddFavorite event, Emitter<FavoriteState> emit) async {
    _firestoreDatabase.addFavorite(event.favorite);
  }

  FutureOr<void> _onRemoveFavorite(
      RemoveFavorite event, Emitter<FavoriteState> emit) async {
    _firestoreDatabase.removeFavorite(event.favoriteId);
  }

  FutureOr<void> _onRemoveFavoriteFromSong(
      RemoveFavoriteFromSong event, Emitter<FavoriteState> emit) async {
    _firestoreDatabase.removeFavoriteFromSong(event.songId);
  }

  FutureOr<void> _onFavoriteExist(
      FavoriteExist event, Emitter<FavoriteState> emit) async {
    _favoriteExistSubscription?.cancel();
    _favoriteExistSubscription = _firestoreDatabase
        .favoriteIdFromSongStream(event.songId)
        .listen(
            (String favoriteId) =>
                add(FavoriteExistSuccess(favoriteId.isNotEmpty, favoriteId)),
            onError: (error) => add(FavoriteExistError("$error")));
  }

  FutureOr<void> _onFavoriteExistSuccess(
      FavoriteExistSuccess event, Emitter<FavoriteState> emit) async {
    emit(FavoriteExistSuccessed(event.exist, event.favoriteId));
  }

  FutureOr<void> _onFavoriteExistError(
      FavoriteExistError event, Emitter<FavoriteState> emit) async {
    emit(FavoriteExistErrored(event.message));
  }

  FutureOr<void> _onUpdateAuthId(
      UpdateAuthId event, Emitter<FavoriteState> emit) async {
    _firestoreDatabase = FirestoreDatabase(uid: event.authId);
    // add(FavoritesLoad()); // chiamo lo stesso evento anche in landing_screen
  }

  Stream<String> favoriteIdFromSongStream(String songId) =>
      _firestoreDatabase.favoriteIdFromSongStream(songId);

  Stream<List<FavoriteFire>> favoritesStream() =>
      _firestoreDatabase.favoritesStream();

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    _favoriteExistSubscription?.cancel();
    return super.close();
  }
}
