import 'package:algolia/algolia.dart';
import 'package:cantapp/song/song_model.dart';

class AlgoliaService {
  AlgoliaService._privateConstructor();

  static final AlgoliaService instance = AlgoliaService._privateConstructor();

  final Algolia _algolia = Algolia.init(
    applicationId: 'MYFNFA4QU7',
    apiKey: 'bcf8b392f6dacaa188445ccf24e2467d',
  );

  AlgoliaIndexReference get _songsIndex =>
      _algolia.instance.index('prod_SONGS');

  Future<List<SongResult>> performMovieQuery({text: String}) async {
    // if (_songsIndex == null) return new List<SongLight>();
    final query = _songsIndex.search(text);
    // if (query == null) return new List<SongLight>();
    final snap = await query.getObjects();
    final songs = snap.hits.map((f) => SongResult.fromJson(f.data)).toList();
    return songs;
  }
}
