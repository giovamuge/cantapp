import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/services/firestore_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorite {
  final String id;

  const Favorite({this.id});
}

class FavoriteFire {
  final String songId;
  final DocumentReference song;
  final DateTime updatedAt;
  final DateTime createdAt;
  final String id;

  const FavoriteFire(
      {this.songId, this.song, this.createdAt, this.updatedAt, this.id});

  FavoriteFire.fromMap(Map maps, String documentId)
      : id = documentId,
        songId = maps["songId"],
        song = maps["song"],
        updatedAt = null,
        createdAt = null;

  // static fromMap(Map maps, String documentId) {
  //   if (maps["createdAt"]) {
  //     final data = Timestamp.fromDate(maps["createdAt"]);
  //   }
  //   // timeago.format(firestoreTime.toDate());

  //   return FavoriteFire(id: maps["id"], songId: maps["songId"]);
  // }

  toJson() => {
        "id": this.id,
        "songId": this.songId,
        "createdAt": this.createdAt,
        "updatedAt": this.updatedAt,
        "song": this.song
      };
}
