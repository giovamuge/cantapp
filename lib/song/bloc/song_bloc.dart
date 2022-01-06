import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cantapp/category/category_model.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  FirestoreDatabase _firestoreDatabase;
  StreamSubscription _songSubscrition;

  SongBloc({@required FirestoreDatabase firestoreDatabase})
      : assert(firestoreDatabase != null),
        _firestoreDatabase = firestoreDatabase,
        super(SongLoading()) {
    on<SongFetched>(_onSongFetched);
    on<SongUpdated>(_onUpdateSong);
    on<SongViewIncremented>(_onSongViewIncremented);
  }

  FutureOr<void> _onSongFetched(
      SongFetched event, Emitter<SongState> emit) async {
    _songSubscrition?.cancel();
    _songSubscrition = _firestoreDatabase
        .songStream(event.songId)
        .listen((event) => add(SongUpdated(event)));
  }

  FutureOr<void> _onUpdateSong(
      SongUpdated event, Emitter<SongState> emit) async {
    print('titolo ' + event.updatedSong.title);
    emit(SongLoaded(event.updatedSong));
  }

  FutureOr<void> _onSongViewIncremented(
      SongViewIncremented event, Emitter<SongState> emit) async {
    _firestoreDatabase
        .incrementView(/*_song.id*/ /* oppure */ event.songId)
        .then((value) async {
      emit(SongViewIncrementedSuccess());
    });
  }

  Future<Song> fetchSong(String songId) =>
      _firestoreDatabase.songStream(songId).first;
}
