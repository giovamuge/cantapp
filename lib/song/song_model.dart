import 'package:cantapp/category/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// potrei usarlo come abstract class
// da inserrire come classe base di song
// così da ridurre le dimensioni nella lista delle canzoni
class SongLight extends Equatable {
  final String id;
  final String title;
  final String artist;
  final int number;
  final List<Link> links;

  SongLight({
    this.title,
    this.id,
    this.artist,
    this.links,
    this.number,
  });

  SongLight.fromSnapshot(
      DocumentSnapshot snapshot, String number, String artist)
      : id = snapshot.documentID, //snapshot.documentID,
        title = snapshot.data["title"],
        artist = snapshot.data["artist"],
        number = snapshot.data["number"],
        links = new List<Link>();

  SongLight.fromJson(Map<String, dynamic> maps)
      : artist = maps["artist"],
        title = maps["title"],
        id = maps["id"],
        number = maps["number"],
        links = new List<Link>();

  static fromMap(Map maps, String id) {
    final links = new List<Link>();
    if (maps["links"] != null) {
      final items = List.from(maps["links"]);
      for (var i = 0; i < items.length; i++) {
        final link = Link.fromMap(items[i]);
        links.add(link);
      }
    }

    return SongLight(
        id: id,
        title: maps["title"],
        artist: maps["artist"],
        links: links,
        number: maps["number"]);
  }

  toJson() {
    return {
      "id": id,
      "title": title,
      "artist": artist,
      "links": links,
      "number": number
    };
  }

  @override
  List<Object> get props => [id, title];

  @override
  String toString() => 'Song { id: $id, title: $title }';
}

class SongResult extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String lyric;
  final int number;

  SongResult.fromJson(Map<String, dynamic> maps)
      : id = maps["id"],
        title = maps["title"],
        lyric = maps["lyric"],
        number = maps["number"],
        artist = maps["artist"] ?? "";

  const SongResult({
    this.id,
    this.title,
    this.artist,
    this.lyric,
    this.number,
  });

  @override
  List<Object> get props => [];
}

abstract class SongBase extends Equatable {
  final String id;
  final String title;
  final String artist;
  final List<Link> links;

  SongBase({this.title, this.id, this.artist, this.links});

  SongBase.fromSnapshot(DocumentSnapshot snapshot, String number, String artist)
      : id = snapshot.documentID, //snapshot.documentID,
        title = snapshot.data["title"],
        artist = snapshot.data["artist"],
        links = new List<Link>();

  SongBase.fromJson(Map<String, dynamic> maps)
      : artist = maps["artist"],
        title = maps["title"],
        id = maps["objectID"],
        links = new List<Link>();

  // static fromMap(Map maps, String id);

  toJson() {
    return {"id": id, "title": title, "artist": artist, "links": links};
  }

  @override
  List<Object> get props => [id, title];

  @override
  String toString() => 'Song { id: $id, title: $title }';
}

class Song extends Equatable {
  final String id;
  final String title;
  final String lyric;
  final String chord;
  final int number;
  final bool isFavorite;
  final List<String> categories;
  final int numberViews;
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
    this.numberViews,
    this.createdAt,
    this.updatedAt,
    this.links,
    this.artist,
  });

  Song.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.documentID,
        title = snapshot.data["title"],
        lyric = snapshot.data["lyric"],
        chord = snapshot.data["chord"],
        number = snapshot.data["number"],
        numberViews = snapshot.data["numberViews"] ?? 0,
        createdAt = snapshot.data["createdAd"],
        updatedAt = snapshot.data["updatedAt"],
        categories = snapshot.data["categories"] != null
            ? new List<String>.from(snapshot.data["categories"])
            : new List<String>(),
        // links = snapshot.data["links"] != null
        //     ? new List<Link>.from(snapshot.data["links"])
        //     : new List<Link>(),
        links = new List<Link>(),
        artist = snapshot.data["artist"],
        isFavorite = false;

  // Song.fromMap(Map maps, String id)
  //     : id = id,
  //       title = maps["title"],
  //       lyric = maps["lyric"],
  //       chord = maps["chord"],
  //       numberViews = maps["numberViews"],
  //       createdAt = maps["createdAd"],
  //       updatedAt = maps["updatedAt"],
  //       categories = maps["categories"] != null
  //           ? new List<String>.from(maps["categories"])
  //           : new List<String>(),
  //       links = maps["links"] != null
  //           ? new List<Map<String, String>>.from(maps["links"])
  //           : new List<Map<String, String>>(),
  //       // links = new List<Link>(),
  //       artist = maps["artist"],
  //       number = maps["number"],
  //       isFavorite = false;

  static fromMap(Map maps, String id) {
    final links = new List<Link>();
    if (maps["links"] != null) {
      final items = List.from(maps["links"]);
      for (var i = 0; i < items.length; i++) {
        final link = Link.fromMap(items[i]);
        links.add(link);
      }
    }

    return Song(
        id: id,
        title: maps["title"],
        lyric: maps["lyric"],
        chord: maps["chord"],
        numberViews: maps["numberViews"],
        createdAt: maps["createdAd"],
        updatedAt: maps["updatedAt"],
        categories: maps["categories"] != null
            ? new List<String>.from(maps["categories"])
            : new List<String>(),
        links: links,
        artist: maps["artist"],
        number: maps["number"],
        isFavorite: false);
  }

  toJson() {
    return {
      "id": id,
      "title": title,
      "lyric": lyric,
      "chord": chord,
      "numberViews": numberViews,
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

// class Song extends SongBase {
//   final String lyric;
//   final String chord;
//   final String number;
//   final bool isFavorite;
//   final List<String> categories;
//   final int numberViews;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   Song({
//     String id,
//     String title,
//     List<Link> links,
//     String artist,
//     this.lyric,
//     this.chord,
//     this.number,
//     this.isFavorite,
//     this.categories,
//     this.numberViews,
//     this.createdAt,
//     this.updatedAt,
//   }) : super(
//           id: id,
//           title: title,
//           links: links,
//           artist: artist,
//         );

//   @override
//   Song.fromSnapshot(DocumentSnapshot snapshot, String number)
//       : lyric = snapshot.data["lyric"],
//         chord = snapshot.data["chord"],
//         number = number,
//         numberViews = snapshot.data["numberViews"] ?? 0,
//         createdAt = snapshot.data["createdAd"],
//         updatedAt = snapshot.data["updatedAt"],
//         categories = snapshot.data["categories"] != null
//             ? new List<String>.from(snapshot.data["categories"])
//             : new List<String>(),
//         isFavorite = false;

//   static Song fromMap(Map maps, String id) {
//     // fromMap(maps, id);
//     final links = new List<Link>();
//     if (maps["links"] != null) {
//       final items = List.from(maps["links"]);
//       for (var i = 0; i < items.length; i++) {
//         final link = Link.fromMap(items[i]);
//         links.add(link);
//       }
//     }

//     return Song(
//         id: id,
//         title: maps["title"],
//         lyric: maps["lyric"],
//         chord: maps["chord"],
//         numberViews: maps["numberViews"],
//         createdAt: maps["createdAd"],
//         updatedAt: maps["updatedAt"],
//         categories: maps["categories"] != null
//             ? new List<String>.from(maps["categories"])
//             : new List<String>(),
//         links: links,
//         artist: maps["artist"],
//         number: maps["number"],
//         isFavorite: false);
//   }

//   toJson() {
//     return {
//       "id": id,
//       "title": title,
//       "lyric": lyric,
//       "chord": chord,
//       "numberViews": numberViews,
//       "categories": categories,
//       "createdAt": createdAt,
//       "updatedAt": updatedAt,
//       "links": links,
//       "artist": artist
//     };
//   }

//   @override
//   List<Object> get props =>
//       [id, title, lyric, chord, isFavorite, categories, number];

//   @override
//   String toString() =>
//       'Song { id: $id, title: $title, lyric: $lyric, chord: $chord, categories: ${categories.join(",")} }';
// }

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

  // Future fetchSongs() async {
  //   var count = 0;
  //   final docs = await databaseReference
  //       .collection("songs")
  //       .orderBy("title")
  //       // .limit(15)
  //       .getDocuments();
  //   final songs = docs.documents.map((doc) => Song.fromSnapshot(doc)).toList();
  //   _items = songs;
  //   notifyListeners();
  // }
}

class Link {
  final String type;
  final String title;
  final String url;

  const Link({this.type, this.title, this.url});

  Link.fromMap(Map maps)
      : type = maps["type"],
        title = maps["title"],
        url = maps["url"];
}

// abstract class Links implements List<Link> {
//   Links.fromMap(Map maps) {
//     final links = new List<Link>();
//     if (maps["links"] != null) {
//       final items = List.from(maps["links"]);
//       for (var i = 0; i < items.length; i++) {
//         final link = Link.fromMap(items[i]);
//         links.add(link);
//       }
//     }

//     return links;
//   }
// }
