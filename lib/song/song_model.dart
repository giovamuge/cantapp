import 'package:cantapp/category/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Song extends Equatable {
  String id;
  String title;
  String lyric;
  String chord;
  String number;
  bool isFavorite = false;
  List<String> categories;
  int counterViews;
  DateTime createdAt;
  DateTime updatedAt;

  Song(this.title, this.lyric);

  Song.fromSnapshot(DocumentSnapshot snapshot, String number)
      : id = snapshot.documentID,
        title = snapshot.data["title"],
        lyric = snapshot.data["lyric"],
        chord = snapshot.data["chord"],
        number = number,
        counterViews = snapshot.data["counterViews"] ?? 0,
        createdAt = snapshot.data["createdAd"],
        updatedAt = snapshot.data["updatedAt"],
        categories = snapshot.data["categories"] != null
            ? new List<String>.from(snapshot.data["categories"])
            : new List<String>();

  Song.formMap(Map maps, String id)
      : id = id,
        title = maps["title"],
        lyric = maps["lyric"],
        chord = maps["chord"],
        counterViews = maps["counterViews"],
        createdAt = maps["createdAd"],
        updatedAt = maps["updatedAt"],
        categories = maps["categories"] != null
            ? new List<String>.from(maps["categories"])
            : new List<String>();

  toJson() {
    return {
      "id": id,
      "title": title,
      "lyric": lyric,
      "chord": chord,
      "counterViews": counterViews,
      "categories": categories
    };
  }

  @override
  List<Object> get props =>
      [id, title, lyric, chord, isFavorite, categories, number];

  @override
  String toString() =>
      'Song { id: $id, title: $title, lyric: $lyric, chord: $chord, categories: ${categories.join(",")} }';
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

  List<Song> findByCategory(Category category) {
    var k = _items
        .where((s) => s.categories.indexOf(category.toString()) > -1)
        .toList();
    return k;
  }

  List<Song> findByFavorite(List<String> favs) {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var favs = prefs.getStringList("Favorites");
    return _items.where((s) => favs.any((f) => f == s.id)).toList();
  }

  Future fetchSongs() async {
    var count = 0;
    final docs = await databaseReference
        .collection("songs")
        .orderBy("title")
        // .limit(15)
        .getDocuments();
    final songs = docs.documents
        .map((doc) => Song.fromSnapshot(doc, '${count++}'))
        .toList();
    _items = songs;
    notifyListeners();
  }
}
