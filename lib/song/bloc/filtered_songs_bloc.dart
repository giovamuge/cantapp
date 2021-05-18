import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cantapp/category/category_model.dart';
import 'package:cantapp/song/bloc/songs_bloc.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

part 'filtered_songs_event.dart';
part 'filtered_songs_state.dart';

class FilteredSongsBloc extends Bloc<FilteredSongsEvent, FilteredSongsState> {
  StreamSubscription _songsSubscription;
  SongLight last;
  Category activeFilter = Categories.first();

  final SongsBloc _songsBloc;

  FilteredSongsBloc({@required SongsBloc songsBloc})
      : assert(songsBloc != null),
        _songsBloc = songsBloc,
        super(initialState(songsBloc)) {
    _songsSubscription = songsBloc.stream.listen((SongState state) =>
        state is SongsLoaded ? add(UpdateSongs(state.songs)) : {});
  }

  // @override
  // Stream<Transition<FilteredSongsEvent, FilteredSongsState>> transformEvents(
  //   Stream<FilteredSongsEvent> events,
  //   TransitionFunction<FilteredSongsEvent, FilteredSongsState> transitionFn,
  // ) {
  //   return super.transformEvents(
  //     events.debounceTime(const Duration(milliseconds: 250)),
  //     transitionFn,
  //   );
  // }

  static FilteredSongsState initialState(SongsBloc songsBloc) {
    final currentState = songsBloc.state;
    if (currentState is SongsLoaded) {
      return FilteredSongsLoaded(currentState.songs, false, Categories.first());
    } else {
      return FilteredSongsLoading(Categories.first());
    }
  }

  @override
  Stream<FilteredSongsState> mapEventToState(FilteredSongsEvent event) async* {
    if (event is UpdateFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is FetchFilter) {
      _songsBloc.add(
          SongsFetch(event.last, /*_visibilityFilter(state)*/ activeFilter));
    } else if (event is UpdateSongs) {
      yield* _mapSongsUpdatedToState(event);
    }
  }

  Stream<FilteredSongsState> _mapUpdateFilterToState(
    UpdateFilter event,
  ) async* {
    // start loading
    yield FilteredSongsLoading(event.filter);
    _songsBloc.add(SongsFetch(null, event.filter));
    activeFilter = event.filter;
    // end loading
  }

  Stream<FilteredSongsState> _mapSongsUpdatedToState(
    UpdateSongs event,
  ) async* {
    if (!(_songsBloc.state is SongsLoaded)) return;
    final SongsLoaded currentSongState = _songsBloc.state;

    yield FilteredSongsLoaded(
      currentSongState.songs,
      currentSongState.hasReachedMax,
      activeFilter,
    );
  }

  // List<SongLight> _mapSongsToFilteredSongs(
  //     List<SongLight> songs, Category filter) {
  //   return songs
  //       .where((cat) => filter.value != CategoryEnum.tutti
  //           ? cat.categories.any((element) => element == filter.toString())
  //           : true)
  //       .toList();
  // }

  // Category _visibilityFilter(FilteredSongsState state) =>
  //     state is FilteredSongsLoaded ? state.activeFilter : Categories.first();

  @override
  Future<void> close() {
    _songsSubscription?.cancel();
    return super.close();
  }
}
