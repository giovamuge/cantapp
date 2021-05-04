import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cantapp/category/category_model.dart';
import 'package:cantapp/song/bloc/songs_bloc.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:equatable/equatable.dart';

part 'filtered_songs_event.dart';
part 'filtered_songs_state.dart';

class FilteredSongsBloc extends Bloc<FilteredSongsEvent, FilteredSongsState> {
  // FilteredsongsBloc() : super(FilteredsongsInitial());

  final SongsBloc _songsBloc;
  StreamSubscription? _songsSubscription;

  FilteredSongsBloc({required SongsBloc songsBloc})
      : _songsBloc = songsBloc,
        super(initialState(songsBloc)) {
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

  @override
  Stream<FilteredSongsState> mapEventToState(FilteredSongsEvent event) async* {
    if (event is UpdateFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is UpdateSongs) {
      yield* _mapSongsUpdatedToState(event);
    }
  }

  Stream<FilteredSongsState> _mapUpdateFilterToState(
    UpdateFilter event,
  ) async* {
    // start loading
    yield FilteredSongsLoading();
    final currentState = _songsBloc.state;
    if (currentState is SongsLoaded) {
      // end loading
      yield FilteredSongsLoaded(
        _mapSongsToFilteredSongs(currentState.songs, event.filter),
        event.filter,
      );
    }
  }

  Stream<FilteredSongsState> _mapSongsUpdatedToState(
    UpdateSongs event,
  ) async* {
    final Category visibilityFilter = state is FilteredSongsLoaded
        ? (state as FilteredSongsLoaded).activeFilter
        : Categories.first();
    yield FilteredSongsLoaded(
      _mapSongsToFilteredSongs(
        (_songsBloc.state as SongsLoaded).songs,
        visibilityFilter,
      ),
      visibilityFilter,
    );
  }

  List<SongLight> _mapSongsToFilteredSongs(
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
