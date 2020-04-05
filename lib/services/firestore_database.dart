import 'dart:async';

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

  // Stream<List<Entry>> entriesStream({Job job}) =>
  //     _service.collectionStream<Entry>(
  //       path: FirestorePath.entries(uid),
  //       queryBuilder: job != null
  //           ? (query) => query.where('jobId', isEqualTo: job.id)
  //           : null,
  //       builder: (data, documentID) => Entry.fromMap(data, documentID),
  //       sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
  //     );

  Stream<List<Song>> songsStream() => _service.collectionStream(
      path: FirestorePath.songs(),
      builder: (data, documentId) => Song.formMap(data, documentId),
      sort: (lhs, rhs) => rhs.title.compareTo(lhs.title));

  // Stream<List<Song>> entriesStream() => _service.collectionStream<Song>(
  //     path: FirestorePath.songs(),
  //     builder: (data, id) => Song.formMap(data, id),
  //     sort: (lhs, rhs) => rhs.title.compareTo(lhs.title));
}
