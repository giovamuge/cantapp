import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cantapp/category/category_model.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/services/full_text_search/full_text_search.dart';
import 'package:cantapp/song/bloc/song_bloc.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

part 'songs_event.dart';
part 'songs_state.dart';

class SongsBloc extends Bloc<SongEvent, SongState> {
  FirestoreDatabase _firestoreDatabase;
  SongLight last;

  SongsBloc({@required FirestoreDatabase firestoreDatabase})
      : assert(firestoreDatabase != null),
        _firestoreDatabase = firestoreDatabase,
        super(SongsLoading());

  @override
  Stream<Transition<SongEvent, SongState>> transformEvents(
    Stream<SongEvent> events,
    TransitionFunction<SongEvent, SongState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 250)),
      transitionFn,
    );
  }

  @override
  Stream<SongState> mapEventToState(
    SongEvent event,
  ) async* {
    if (event is SongsFetch && (!_hasReachedMax(state) || _isInitial(event))) {
      yield* _mapLoadSongsToState(event);
    } else if (event is SongsUpdated) {
      yield* _mapSongsUpdateToState(event);
    } else if (event is SongsAuthIdUpdated) {
      yield* _mapUpdateAuthIdToState(event);
    }
  }

  Stream<SongState> _mapLoadSongsToState(SongsFetch event) async* {
    _firestoreDatabase
        .songsLightFuture(event.last, event.category)
        .then((songs) => add(SongsUpdated(songs, _isInitial(event))));
  }

  Stream<SongState> _mapSongsUpdateToState(SongsUpdated event) async* {
    final songs = event.songs;
    final hasReachedMax =
        songs.isEmpty || songs.length < 15; // if minium of numOfPages

    // imposta l'ultima canzone
    // last = !hasReachedMax ? songs.last : last; // non più necessario

    if (!(state is SongsLoaded) || event.isInitial) {
      yield SongsLoaded(songs, hasReachedMax);
      return;
    }

    final SongsLoaded currentState = state as SongsLoaded;
    final List<SongLight> songAdded = List.of(currentState.songs ?? [])
      ..addAll(songs.isNotEmpty ? event.songs : []);

    yield SongsLoaded(songAdded, hasReachedMax);

    // qui potrei salvare in fulltextsearch_songs
    // final numberOfSongs = await FullTextSearch.instance.countSongs();
    // if (numberOfSongs == event.songs.length) return;
    // if (numberOfSongs > 0) await FullTextSearch.instance.deleteSongs();
    // FullTextSearch.instance.insertSongs(event.songs);
  }

  _mapUpdateAuthIdToState(SongsAuthIdUpdated event) {
    _firestoreDatabase = FirestoreDatabase(uid: event.authId);
  }

  Stream<List<SongLight>> songsFromCategorySearchStream(Category category) =>
      _firestoreDatabase.songsFromCategorySearchStream(category: category);

  Stream<List<SongLight>> activitySongsStream(int activity) =>
      _firestoreDatabase.activitySongsStream(activity);

  Stream<List<SongLight>> songsSearchStream(String query) =>
      _firestoreDatabase.songsSearchStream(textSearch: query);

  bool _hasReachedMax(SongState state) =>
      state is SongsLoaded && state.hasReachedMax;

  bool _isInitial(SongEvent event) => event is SongsFetch && event.last == null;

  @override
  Future<void> close() {
    return super.close();
  }
}
