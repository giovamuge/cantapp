import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cantapp/category/category_model.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:equatable/equatable.dart';

part 'songs_event.dart';
part 'songs_state.dart';

class SongsBloc extends Bloc<SongEvent, SongState> {
  FirestoreDatabase _firestoreDatabase;
  StreamSubscription? _songsSubscription;

  SongsBloc({required FirestoreDatabase firestoreDatabase})
      : _firestoreDatabase = firestoreDatabase,
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
    if (event is UpdateAuthIdSong) {
      yield* _mapUpdateAuthIdToState(event);
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

  _mapUpdateAuthIdToState(UpdateAuthIdSong event) {
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
