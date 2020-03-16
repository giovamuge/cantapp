import 'package:bloc/bloc.dart';
import 'package:cantapp/song/song_event.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/song_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
// import 'package:http/http.dart' as http;

class SongBloc extends Bloc<SongEvent, SongState> {
  // final http.Client httpClient;
  final Firestore databaseReference;

  SongBloc({@required this.databaseReference});

  @override
  SongState get initialState => SongUninitialized();

  @override
  Stream<SongState> mapEventToState(SongEvent event) async* {
    final currentState = state;
    var count = 0;
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is SongUninitialized) {
          final songs = await _fetchSongs(0, 20);
          final songss =
              songs.documents.map((doc) => Song.fromSnapshot(doc, '${count++}')).toList();
          yield SongLoaded(songs: songss, hasReachedMax: false);
          return;
        }
        if (currentState is SongLoaded) {
          final songs = await _fetchSongs(currentState.songs.length, 20);
          final songss =
              songs.documents.map((doc) => Song.fromSnapshot(doc, '${count++}')).toList();
          yield songs == null
              ? currentState.copyWith(hasReachedMax: true)
              : SongLoaded(
                  songs: currentState.songs + songss,
                  hasReachedMax: false,
                );
        }
      } catch (_) {
        yield SongError();
        print(_);
      }
    }
  }

  bool _hasReachedMax(SongState state) =>
      state is SongLoaded && state.hasReachedMax;

  Future<QuerySnapshot> _fetchSongs(int startIndex, int limit) async {
    var result =
        databaseReference.collection("songs").orderBy("title").getDocuments();

    return result;

    // final response = await httpClient.get(
    //     'https://jsonplaceholder.typicode.com/songs?_start=$startIndex&_limit=$limit');
    // if (response.statusCode == 200) {
    //   final data = json.decode(response.body) as List;
    //   return data.map((rawSong) {
    //     return Song(
    //       // id: rawSong['id'],
    //       rawSong['title'],
    //       rawSong['body'],
    //     );
    //   }).toList();
    // } else {
    //   throw Exception('error fetching songs');
    // }
  }

  @override
  Stream<SongState> transformEvents(
    Stream<SongEvent> events,
    Stream<SongState> Function(SongEvent event) next,
  ) {
    return super.transformEvents(
      //events.debounceTime(
      events.timeout(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }
}
