import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cantapp/category/category_model.dart';
import 'package:cantapp/song/bloc/songs_bloc.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'filtered_songs_event.dart';
part 'filtered_songs_state.dart';

class FilteredSongsBloc extends Bloc<FilteredSongsEvent, FilteredSongsState> {
  // FilteredsongsBloc() : super(FilteredsongsInitial());

  final SongsBloc _songsBloc;
  StreamSubscription _songsSubscription;

  FilteredSongsBloc({@required SongsBloc songsBloc})
      : assert(songsBloc != null),
        _songsBloc = songsBloc,
        super(initialState(songsBloc)) {
    on<UpdateFilter>(_onUpdateFilter);
    on<UpdateSongs>(_onSongsUpdated);

    _songsSubscription = songsBloc.stream.listen((state) {
      if (state is SongsLoaded) {
        add(UpdateSongs((songsBloc.state as SongsLoaded).songs));
      }
    });
  }

  static FilteredSongsState initialState(SongsBloc songsBloc) {
    if (songsBloc.state is SongsLoaded) {
      final songLoaded = songsBloc.state as SongsLoaded;
      return FilteredSongsLoaded(songLoaded.songs, Categories.first());
    } else {
      return FilteredSongsLoading();
    }
  }

  FutureOr<void> _onUpdateFilter(
      UpdateFilter event, Emitter<FilteredSongsState> emit) {
    // start loading
    emit(FilteredSongsLoading());
    final currentState = _songsBloc.state;
    if (currentState is SongsLoaded) {
      // end loading
      emit(FilteredSongsLoaded(
        _onSongsToFilteredSongs(currentState.songs, event.filter),
        event.filter,
      ));
    }
  }

  FutureOr<void> _onSongsUpdated(
      UpdateSongs event, Emitter<FilteredSongsState> emit) {
    final Category visibilityFilter = state is FilteredSongsLoaded
        ? (state as FilteredSongsLoaded).activeFilter
        : Categories.first();
    emit(FilteredSongsLoaded(
      _onSongsToFilteredSongs(
        (_songsBloc.state as SongsLoaded).songs,
        visibilityFilter,
      ),
      visibilityFilter,
    ));
  }

  List<SongLight> _onSongsToFilteredSongs(
      List<SongLight> songs, Category filter) {
    return songs.where((cat) {
      if (filter.value == CategoryEnum.tutti) {
        return true;
      } else {
        return cat.categories.any((element) => element == filter.toString());
      }
    }).toList();
  }

  @override
  Future<void> close() {
    _songsSubscription?.cancel();
    return super.close();
  }
}
