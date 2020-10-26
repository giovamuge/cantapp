import 'dart:async';

import 'package:cantapp/category/category_model.dart';
import 'package:cantapp/services/firestore_path.dart';
import 'package:cantapp/services/firestore_service.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
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

  Future<void> incrementView(String songId) async => await _service.updateData(
        path: FirestorePath.song(songId),
        data: {'numberViews': FieldValue.increment(1)},
      );

  Stream<List<SongLight>> songsFromCategorySearchStream({Category category}) =>
      _service.collectionStream<SongLight>(
          path: FirestorePath.songs(),
          queryBuilder: (query) => query
              .where('categories', arrayContains: category.toString())
              .orderBy('title'),
          builder: (data, documentID) => SongLight.fromMap(data, documentID));

  Stream<List<Song>> songsSearchStream({String textSearch}) =>
      _service.collectionStream<Song>(
          path: FirestorePath.songs(),
          queryBuilder: (query) => query
              .where('keywords', arrayContains: textSearch)
              .orderBy('title'),
          builder: (data, documentID) => Song.fromMap(data, documentID));

  Stream<List<Song>> songsStream() => _service.collectionStream(
      path: FirestorePath.songs(),
      queryBuilder: (query) => query.orderBy('title'),
      builder: (data, documentId) => Song.fromMap(data, documentId));

  Stream<List<SongLight>> songsLightStream() => _service.collectionStream(
      path: FirestorePath.songs(),
      queryBuilder: (query) => query.orderBy('title'),
      builder: (data, documentId) => SongLight.fromMap(data, documentId));

  Stream<Song> songStream(String id) => _service.documentStream(
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
  //sort: (lhs, rhs) => rhs.title.compareTo(lhs.title));
}
