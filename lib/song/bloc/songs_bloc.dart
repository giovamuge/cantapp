import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cantapp/category/category_model.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'songs_event.dart';
part 'songs_state.dart';

class SongsBloc extends Bloc<SongsEvent, SongsState> {
  FirestoreDatabase _firestoreDatabase;
  Map<CategoryEnum, SongsLoaded> _mapFilteredSongs;
  Category activeFilter = Categories.first();

  SongsBloc({@required FirestoreDatabase firestoreDatabase})
      : assert(firestoreDatabase != null),
        _firestoreDatabase = firestoreDatabase,
        super(SongsLoading(Categories.first())) {
    on<SongsFetch>(_onLoadSongs);
    on<SongsUpdated>(_onSongsUpdate);
    on<SongsAuthIdUpdated>(_onUpdateAuthId);
    on<UpdateFilter>(_onUpdateFilter);

    _mapFilteredSongs = Map.fromIterable(Categories.items,
        key: (c) => c.value, value: (c) => SongsLoaded());
  }

  // @override
  // Stream<Transition<SongEvent, State>> transformTransitions(
  //   Stream<Transition<SongEvent, State>> transitions,
  // ) {
  //   return transitions.debounceTime(const Duration(milliseconds: 250));
  // }

  // @override
  // FutureOr<void> mapEventToState(
  //   SongsEvent event,
  // ) async {
  //   if (event is SongsFetch &&
  //       (!_hasReachedMaxOfFilter(activeFilter) || _isInitial(event))) {
  //     yield* _mapLoadSongsToState(event);
  //   } else if (event is SongsUpdated) {
  //     yield* _mapSongsUpdateToState(event);
  //   } else if (event is SongsAuthIdUpdated) {
  //     yield* _mapUpdateAuthIdToState(event);
  //   } else if (event is UpdateFilter) {
  //     yield* _mapUpdateFilterToState(event);
  //   }
  // }

  FutureOr<void> _onUpdateFilter(
      UpdateFilter event, Emitter<SongsState> emit) async {
    activeFilter = event.filter;
    // start loading
    emit(SongsLoading(activeFilter));

    if (_isFilterInitial(activeFilter)) {
      add(SongsFetch(null));
      return;
    }

    emit(SongsLoaded(
      _songsOfFilter(activeFilter),
      _hasReachedMaxOfFilter(activeFilter),
      activeFilter,
    ));
    // end loading
  }

  FutureOr<void> _onLoadSongs(
      SongsFetch event, Emitter<SongsState> emit) async {
    _firestoreDatabase
        .songsLightFuture(event.last, activeFilter)
        .then((songs) => add(SongsUpdated(songs, _isInitial(event))));
  }

  FutureOr<void> _onSongsUpdate(
      SongsUpdated event, Emitter<SongsState> emit) async {
    final songs = event.songs;
    final hasReachedMax =
        songs.isEmpty || songs.length < 15; // if minium of numOfPages

    // imposta l'ultima canzone
    // last = !hasReachedMax ? songs.last : last; // non più necessario

    if (!(state is SongsLoaded) || event.isInitial) {
      _mapNewState(songs, hasReachedMax, activeFilter, emit);
      return;
    }

    // final SongsLoaded currentState = state as SongsLoaded;
    final List<SongLight> songAdded =
        List.of(/*currentState.songs*/ _songsOfFilter(activeFilter) ?? [])
          ..addAll(songs.isNotEmpty ? event.songs : []);

    _mapNewState(songAdded, hasReachedMax, activeFilter, emit);
  }

  FutureOr<void> _mapNewState(List<SongLight> songs, bool hasReachedMax,
      Category activeFilter, Emitter<SongsState> emit) async {
    final SongsLoaded newState =
        SongsLoaded(songs, hasReachedMax, activeFilter);
    _mapFilteredSongs[activeFilter.value] = newState;
    emit(newState);
  }

  _onUpdateAuthId(SongsAuthIdUpdated event, Emitter<SongsState> emit) {
    _firestoreDatabase = FirestoreDatabase(uid: event.authId);
  }

  Stream<List<SongLight>> songsFromCategorySearchStream(Category category) =>
      _firestoreDatabase.songsFromCategorySearchStream(category: category);

  Stream<List<SongLight>> activitySongsStream(int activity) =>
      _firestoreDatabase.activitySongsStream(activity);

  Stream<List<SongLight>> songsSearchStream(String query) =>
      _firestoreDatabase.songsSearchStream(textSearch: query);

  bool _isInitial(SongsEvent event) =>
      event is SongsFetch && event.last == null;

  SongsLoaded _songsLoadedOfFilter(Category filter) =>
      _mapFilteredSongs[filter.value];

  List<SongLight> _songsOfFilter(Category filter) =>
      _songsLoadedOfFilter(filter).songs;

  bool _hasReachedMaxOfFilter(Category filter) =>
      _songsLoadedOfFilter(filter).hasReachedMax;

  bool _isFilterInitial(Category filter) =>
      !_hasReachedMaxOfFilter(filter) && _songsOfFilter(filter).isEmpty;

  @override
  Future<void> close() {
    return super.close();
  }
}
