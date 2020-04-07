import 'dart:async';

import 'package:cantapp/category/category_model.dart';
import 'package:cantapp/services/firestore_path.dart';
import 'package:cantapp/services/firestore_service.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:meta/meta.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  // Future<void> setJob(Job job) async => await _service.setData(
  //       path: FirestorePath.job(uid, job.id),
  //       data: job.toMap(),
  //     );

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

  // Stream<Job> jobStream({@required String jobId}) => _service.documentStream(
  //       path: FirestorePath.job(uid, jobId),
  //       builder: (data, documentId) => Job.fromMap(data, documentId),
  //     );

  // Stream<List<Job>> jobsStream() => _service.collectionStream(
  //       path: FirestorePath.jobs(uid),
  //       builder: (data, documentId) => Job.fromMap(data, documentId),
  //     );

  // Future<void> setEntry(Entry entry) async => await _service.setData(
  //       path: FirestorePath.entry(uid, entry.id),
  //       data: entry.toMap(),
  //     );

  // Future<void> deleteEntry(Entry entry) async =>
  //     await _service.deleteData(path: FirestorePath.entry(uid, entry.id));

  Stream<List<Song>> songsFromCategorySearchStream({Category category}) =>
      _service.collectionStream<Song>(
          path: FirestorePath.songs(),
          queryBuilder: (query) => query
              .where('categories', arrayContains: category.toString())
              .orderBy('title'),
          builder: (data, documentID) => Song.formMap(data, documentID));

  Stream<List<Song>> songsSearchStream({String textSearch}) =>
      _service.collectionStream<Song>(
          path: FirestorePath.songs(),
          queryBuilder: (query) => query
              .where('keywords', arrayContains: textSearch)
              .orderBy('title'),
          builder: (data, documentID) => Song.formMap(data, documentID));

  Stream<List<Song>> songsStream() => _service.collectionStream(
      path: FirestorePath.songs(),
      queryBuilder: (query) => query.orderBy('title'),
      builder: (data, documentId) => Song.formMap(data, documentId));
      //sort: (lhs, rhs) => rhs.title.compareTo(lhs.title));
}
