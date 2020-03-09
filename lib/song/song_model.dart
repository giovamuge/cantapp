import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Song extends Equatable {
  String id;
  String title;
  String lyric;
  bool isFavorite = false;
  List<dynamic> categories;

  Song(this.title, this.lyric);

  Song.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.documentID,
        title = snapshot.data["title"],
        lyric = snapshot.data["lyric"];
  // categories = snapshot.data["categories"] != null
  //     ? new List<String>.from(snapshot.data["categories"])
  //     : null;

  Song.formMap(Map maps, String id)
      : id = id,
        title = maps["title"],
        lyric = maps["lyric"],
        categories = maps["categories"] != null
            ? new List<String>.from(maps["categories"])
            : null;
  // categories = maps["categories"];

  toJson() {
    return {
      "id": id,
      "title": title,
      "lyric": lyric,
      // "categories": categories
    };
  }

  @override
  List<Object> get props => [id, title, lyric, isFavorite, categories];

  @override
  String toString() => 'Song { id: $id }';
}

class Songs with ChangeNotifier {
  final Firestore databaseReference;

  Songs({@required this.databaseReference});

  List<Song> _items = [];

  List<Song> get items {
    return [..._items];
  }

  set items(List<Song> value) {
    _items = value;
  }

  Future fetchSongs() async {
    final docs = await databaseReference
        .collection("songs")
        .orderBy("title")
        .getDocuments();
    final songs = docs.documents.map((doc) => Song.fromSnapshot(doc)).toList();
    _items = songs;
    notifyListeners();
  }
}
