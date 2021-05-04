import 'dart:async';

import 'package:cantapp/category/category_model.dart';
import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/services/firestore_path.dart';
import 'package:cantapp/services/firestore_service.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import 'firebase_auth_service.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  // Future<void> deleteJob(Job job) async {
  //   // delete where entry.jobId == job.jobId
  //   final allEntries = await entriesStream(job: job).first;
  //   for (Entry entry in allEntries) {
  //     if (entry.jobId == job.id) {
  //       await deleteEntry(entry);
  //     }
  //   }
  //   // delete job
  //   await _service.deleteData(path: FirestorePath.job(uid, job.id));
  // }

  Future<void> removeFavorite(String favoriteId) async =>
      await _service.deleteData(path: FirestorePath.favorite(uid, favoriteId));

  Future<void> removeFavoriteFromSong(String songId) async {
    // delete where entry.jobId == job.jobId
    final allFavorites = await favoritesStream().first;
    for (FavoriteFire favorite in allFavorites) {
      if (favorite.songId == songId) {
        await removeFavorite(favorite.id);
      }
    }
  }

  Future<void> incrementView(String songId) async => await _service.updateData(
        path: FirestorePath.song(songId),
        data: {'numberViews': FieldValue.increment(1)},
      );

  Stream<List<SongLight>> songsFromCategorySearchStream({Category category}) =>
      _service.collectionStream<SongLight>(
          path: FirestorePath.songs(),
          builder: (data, documentID) => SongLight.fromMap(data, documentID),
          queryBuilder: (query) => category.value == CategoryEnum.tutti
              ? query.orderBy('title')
              : query
                  .where('categories', arrayContains: category.toString())
                  .orderBy('title', descending: false));

  Stream<List<SongLight>> songsSearchStream({String textSearch}) =>
      _service.collectionStream<SongLight>(
          path: FirestorePath.songs(),
          queryBuilder: (query) => query
              .where('keywords', arrayContains: textSearch)
              .orderBy('title'),
          builder: (data, documentID) => SongLight.fromMap(data, documentID));

  Stream<List<Song>> songsStream() => _service.collectionStream<Song>(
      path: FirestorePath.songs(),
      queryBuilder: (query) => query.orderBy('title'),
      builder: (data, documentId) => Song.fromMap(data, documentId));

  Stream<List<SongLight>> songsLightStream() =>
      _service.collectionStream<SongLight>(
          path: FirestorePath.songs(),
          queryBuilder: (query) => query.orderBy('title'),
          builder: (data, documentId) => SongLight.fromMap(data, documentId));

  Stream<Song> songStream(String id) => _service.documentStream<Song>(
      path: FirestorePath.song(id),
      builder: (data, documentId) => Song.fromMap(data, documentId));

  Stream<List<SongLight>> activitySongsStream(int type) =>
      _service.collectionStream(
          path: FirestorePath.songs(),
          queryBuilder: (query) {
            var res = query;
            if (type == 0) {
              res = res.orderBy('numberViews', descending: true);
            } else if (type == 1) {
              res = res.orderBy('createdAt', descending: true);
            } else {
              res = res.orderBy('title', descending: true);
            }
            res = res.limit(15);
            return res;
          },
          builder: (data, documentId) => SongLight.fromMap(data, documentId));

  Stream<User> userStream(String userId) => _service.documentStream<User>(
      path: FirestorePath.user(userId),
      builder: (data, documentId) => User.fromMap(data));

  Future<void> setUser(User user, String userId) async => await _service
      .setData(path: FirestorePath.user(userId), data: user.toJson());

  Future<void> addFavorite(FavoriteFire favorite) async => await _service
      .addData(path: FirestorePath.favorites(uid), data: favorite.toJson());

  Stream<List<FavoriteFire>> favoritesStream() =>
      _service.collectionStream<FavoriteFire>(
          path: FirestorePath.favorites(uid),
          builder: (data, documentId) =>
              FavoriteFire.fromMap(data, documentId));

  Stream<FavoriteFire> favoriteStream(String favoriteId) =>
      _service.documentStream<FavoriteFire>(
          path: FirestorePath.favorite(uid, favoriteId),
          builder: (data, documentId) =>
              FavoriteFire.fromMap(data, documentId));

  Stream<bool> existSongInFavoriteStream(String songId) =>
      FirebaseFirestore.instance
          .collection(FirestorePath.favorites(uid))
          .where("songId", isEqualTo: songId)
          .snapshots()
          .map((value) => value.docs.isNotEmpty);

  Stream<String> favoriteIdFromSongStream(String songId) =>
      FirebaseFirestore.instance
          .collection(FirestorePath.favorites(uid))
          .where("songId", isEqualTo: songId)
          .snapshots()
          .map((value) => value.docs.first.id);
  //     .map((value) {
  //   final docs = value.docs;
  //   final empty = docs.isEmpty;
  //   if (empty) return "";
  //   return value?.docs?.first?.id;
  // });

  // void setFavorite(String userId, String songId) => _service
  //     .setData(path: FirestorePath.user(userId), data: );
}
