import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cantapp/category/category_model.dart';
import 'package:cantapp/services/firestore_database.dart';
// import 'package:cantapp/services/full_text_search/full_text_search.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'songs_event.dart';
part 'songs_state.dart';

class SongsBloc extends Bloc<SongEvent, SongState> {
  FirestoreDatabase _firestoreDatabase;
  StreamSubscription _songsSubscription;

  SongsBloc({@required FirestoreDatabase firestoreDatabase})
      : assert(firestoreDatabase != null),
        _firestoreDatabase = firestoreDatabase,
        super(SongsLoading()) {
    on<SongsFetch>(_onLoadSongs);
    on<SongsUpdated>(_onSongsUpdate);
    on<UpdateAuthIdSong>(_onUpdateAuthId);
  }

  FutureOr<void> _onLoadSongs(SongsFetch event, Emitter<SongState> emit) async {
    _songsSubscription?.cancel();
    _songsSubscription = _firestoreDatabase
        .songsLightStream()
        // necessario per non dove ricaricare
        // ogni volta la lista intera delle canzoni
        .take(1)
        .listen((songs) => add(SongsUpdated(songs)));
  }

  FutureOr<void> _onSongsUpdate(
      SongsUpdated event, Emitter<SongState> emit) async {
    return emit(SongsLoaded(event.songs));
  }

  _onUpdateAuthId(UpdateAuthIdSong event, Emitter<SongState> emit) {
    _firestoreDatabase = FirestoreDatabase(uid: event.authId);
  }

  Stream<List<SongLight>> songsFromCategorySearchStream(Category category) =>
      _firestoreDatabase.songsFromCategorySearchStream(category: category);

  Stream<List<SongLight>> activitySongsStream(int activity) =>
      _firestoreDatabase.activitySongsStream(activity);

  Stream<List<SongLight>> songsSearchStream(String query) =>
      _firestoreDatabase.songsSearchStream(textSearch: query);

  @override
  Future<void> close() {
    _songsSubscription?.cancel();
    return super.close();
  }
}
