import 'package:cantapp/favorite/favorite.dart';

class FirestorePath {
  // static String job(String uid, String jobId) => 'users/$uid/jobs/$jobId';
  // static String jobs(String uid) => 'users/$uid/jobs';
  // static String entry(String uid, String entryId) =>
  //     'users/$uid/entries/$entryId';
  // static String entries(String uid) => 'users/$uid/entries';

  static String songs() => 'songs';
  static String song(String songId) => 'songs/$songId';

  static String categories() => 'categories';

  static String users() => 'users';
  static String user(String userId) => 'users/$userId';

  static String favorites(String userId) => '${user(userId)}/favorites';
  static String favorite(String userId, String favoriteId) =>
      '${user(userId)}/favorites/$favoriteId';

  static String songsIndex(String version) => 'songs_index/$version';
}
