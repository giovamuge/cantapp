import 'package:cantapp/category/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Song extends Equatable {
  final String id;
  final String title;
  final String lyric;
  final String chord;
  final String number;
  final bool isFavorite;
  final List<String> categories;
  final int counterViews;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Link> links;
  final String artist;

  Song({
    this.title,
    this.lyric,
    this.id,
    this.chord,
    this.number,
    this.isFavorite,
    this.categories,
    this.counterViews,
    this.createdAt,
    this.updatedAt,
    this.links,
    this.artist,
  });

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
            : new List<String>(),
        links = snapshot.data["links"] != null
            ? new List<Link>.from(snapshot.data["links"])
            : new List<Link>(),
        artist = snapshot.data["artist"],
        isFavorite = false;

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
            : new List<String>(),
        links = maps["links"] != null
            ? new List<Link>.from(maps["links"])
            : new List<Link>(),
        artist = maps["artist"],
        number = maps["number"],
        isFavorite = false;

  toJson() {
    return {
      "id": id,
      "title": title,
      "lyric": lyric,
      "chord": chord,
      "counterViews": counterViews,
      "categories": categories,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "links": links,
      "artist": artist
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

  List<Song> get items => [..._items];
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

class Link {
  String type;
  String title;
  String url;
}
