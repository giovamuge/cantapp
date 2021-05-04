import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  FirestoreDatabase _firestoreDatabase;
  StreamSubscription _songSubscrition;

  SongBloc({required FirestoreDatabase firestoreDatabase})
      : assert(firestoreDatabase != null),
        _firestoreDatabase = firestoreDatabase,
        super(SongLoading());

  @override
  Stream<SongState> mapEventToState(
    SongEvent event,
  ) async* {
    if (event is SongFetched) {
      yield* _mapSongFetchedToState(event);
    }
    if (event is SongUpdated) {
      yield* _mapUpdateSongToState(event);
    }
    if (event is SongViewIncremented) {
      yield* _mapSongViewIncrementedToState(event);
    }
  }

  Stream<SongState> _mapSongFetchedToState(SongFetched event) async* {
    _songSubscrition?.cancel();
    _songSubscrition = _firestoreDatabase
        .songStream(event.songId)
        .listen((event) => add(SongUpdated(event)));
  }

  Stream<SongState> _mapUpdateSongToState(SongUpdated event) async* {
    print('titolo ' + event.updatedSong.title);
    yield SongLoaded(event.updatedSong);
  }

  Stream<SongState> _mapSongViewIncrementedToState(
      SongViewIncremented event) async* {
    _firestoreDatabase
        .incrementView(/*_song.id*/ /* oppure */ event.songId)
        .then((value) async* {
      yield SongViewIncrementedSuccess();
    });
  }

  Future<Song> fetchSong(String songId) =>
      _firestoreDatabase.songStream(songId).first;
}
