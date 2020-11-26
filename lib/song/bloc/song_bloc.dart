import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  // SongBloc() : super(SongInitial());

  final FirestoreDatabase _firestoreDatabase;
  StreamSubscription _todosSubscription;

  SongBloc({@required FirestoreDatabase firestoreDatabase})
      : assert(firestoreDatabase != null),
        _firestoreDatabase = firestoreDatabase,
        super(SongsLoading());

  @override
  Stream<SongState> mapEventToState(
    SongEvent event,
  ) async* {
    if (event is SongsFetch) {
      yield* _mapLoadSongsToState();
    }
  }

  Stream<SongState> _mapLoadSongsToState() async* {
    _todosSubscription?.cancel();
    _todosSubscription = _firestoreDatabase
        .songsStream()
        .listen((todos) => add(SongsUpdated(todos)));
  }

  @override
  Future<void> close() {
    _todosSubscription?.cancel();
    return super.close();
  }
}
