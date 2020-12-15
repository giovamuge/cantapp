import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'songs_event.dart';
part 'songs_state.dart';

class SongsBloc extends Bloc<SongEvent, SongState> {
  // SongBloc() : super(SongInitial());

  final FirestoreDatabase _firestoreDatabase;
  StreamSubscription _songsSubscription;

  SongsBloc({@required FirestoreDatabase firestoreDatabase})
      : assert(firestoreDatabase != null),
        _firestoreDatabase = firestoreDatabase,
        super(SongsLoading());

  @override
  Stream<SongState> mapEventToState(
    SongEvent event,
  ) async* {
    if (event is SongsFetch) {
      yield* _mapLoadSongsToState();
    } else if (event is SongsUpdated) {
      yield* _mapSongsUpdateToState(event);
    }
  }

  Stream<SongState> _mapLoadSongsToState() async* {
    _songsSubscription?.cancel();
    _songsSubscription = _firestoreDatabase
        .songsLightStream()
        .listen((songs) => add(SongsUpdated(songs)));
  }

  Stream<SongState> _mapSongsUpdateToState(SongsUpdated event) async* {
    yield SongsLoaded(event.songs);
  }

  @override
  Future<void> close() {
    _songsSubscription?.cancel();
    return super.close();
  }
}