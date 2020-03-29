import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Song extends Equatable {
  String id;
  String title;
  String lyric;
  String number;
  bool isFavorite = false;
  List<String> categories;

  Song(this.title, this.lyric);

  Song.fromSnapshot(DocumentSnapshot snapshot, String number)
      : id = snapshot.documentID,
        title = snapshot.data["title"],
        lyric = snapshot.data["lyric"],
        number = number,
        categories = snapshot.data["categories"] != null
            ? new List<String>.from(snapshot.data["categories"])
            : new List<String>();

  Song.formMap(Map maps, String id)
      : id = id,
        title = maps["title"],
        lyric = maps["lyric"],
        categories = maps["categories"] != null
            ? new List<String>.from(maps["categories"])
            : new List<String>();
  // categories = maps["categories"];

  toJson() {
    return {"id": id, "title": title, "lyric": lyric, "categories": categories};
  }

  @override
  List<Object> get props => [id, title, lyric, isFavorite, categories, number];

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
    var count = 0;
    final docs = await databaseReference
        .collection("songs")
        .orderBy("title")
        .getDocuments();
    final songs = docs.documents
        .map((doc) => Song.fromSnapshot(doc, '${count++}'))
        .toList();
    _items = songs;
    notifyListeners();
  }
}
