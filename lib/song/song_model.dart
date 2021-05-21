import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// potrei usarlo come abstract class
// da inserrire come classe base di song
// così da ridurre le dimensioni nella lista delle canzoni
class SongLight extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String number;
  final List<Link> links;
  final bool isChord;
  final List<String> categories;
  final DateTime updatedAt;
  final DateTime createdAt;

  SongLight({
    this.title,
    this.id,
    this.artist,
    this.links,
    this.number,
    this.isChord = false,
    this.categories,
    this.updatedAt,
    this.createdAt,
  });

  SongLight.fromSnapshot(
      DocumentSnapshot snapshot, String number, String artist)
      : id = snapshot.id, //snapshot.documentID,
        title = snapshot.data()["title"],
        artist = snapshot.data()["artist"],
        number = snapshot.data()["number"],
        updatedAt = snapshot.data()["updatedAt"],
        createdAt = snapshot.data()["createdAt"],
        isChord = snapshot.data()["chord"] != null,
        categories = snapshot.data()["categories"] != null
            ? new List<String>.from(snapshot.data()["categories"])
            : [],
        links = [];

  SongLight.fromJson(Map<String, dynamic> maps)
      : artist = maps["artist"],
        title = maps["title"],
        id = maps["id"],
        number = maps["number"],
        updatedAt = maps["updatedAt"],
        createdAt = maps["createdAt"],
        isChord = maps["chord"] != null,
        categories = maps["categories"] != null
            ? new List<String>.from(maps["categories"])
            : [],
        links = [];

  SongLight.fromJsonIndexSongs(Map<String, dynamic> maps)
      : title = maps["title"],
        artist = maps["artist"],
        id = maps["id"],
        categories = [],
        createdAt = null,
        links = [],
        number = "",
        updatedAt = null,
        isChord = false;

  static fromMap(Map maps, String id) {
    final List<Link> links = [];
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
        updatedAt: maps["updatedAt"],
        createdAt: maps["createdAt"],
        links: links,
        isChord: maps["chord"] != null,
        categories: maps["categories"] != null
            ? new List<String>.from(maps["categories"])
            : [],
        number: maps["number"]);
  }

  toJson() {
    return {
      "id": id,
      "title": title,
      "artist": artist,
      "links": links,
      "number": number,
      "updatedAt": updatedAt,
      "createdAt": createdAt,
    };
  }

  toMap() {
    return {
      "title": title,
      "artist": artist,
      "id": id,
      // "updatedAt": updatedAt,
      // "createdAt": createdAt,
    };
  }

  @override
  List<Object> get props => [id, title, artist, links, number, updatedAt];

  @override
  String toString() =>
      'Song { id: $id, number: $number, artist: $artist, title: $title, }';
}

class SongResult extends Equatable {
  final String id;
  final String objectID;
  final String title;
  final String artist;
  final String lyric;
  final String number;

  SongResult.fromJson(Map<String, dynamic> maps, String objectID)
      : id = maps["id"],
        objectID = objectID,
        title = maps["title"],
        lyric = maps["lyric"],
        number = maps["number"],
        artist = maps["artist"] ?? "Artista sconosciuto";

  const SongResult({
    this.id,
    this.objectID,
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
      : id = snapshot.id, //snapshot.documentID,
        title = snapshot.data()["title"],
        artist = snapshot.data()["artist"] ?? "Artista conosciuto",
        links = [];

  SongBase.fromJson(Map<String, dynamic> maps)
      : artist = maps["artist"] ?? "Artista conosciuto",
        title = maps["title"],
        id = maps["objectID"],
        links = [];

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
  final String number;
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
      : id = snapshot.id,
        title = snapshot.data()["title"],
        lyric = snapshot.data()["lyric"],
        chord = snapshot.data()["chord"],
        number = snapshot.data()["number"],
        numberViews = snapshot.data()["numberViews"] ?? 0,
        createdAt = snapshot.data()["createdAd"],
        updatedAt = snapshot.data()["updatedAt"],
        categories = snapshot.data()["categories"] != null
            ? new List<String>.from(snapshot.data()["categories"])
            : [],
        // links = snapshot.data()["links"] != null
        //     ? new List<Link>.from(snapshot.data()["links"])
        //     : [],
        links = [],
        artist = snapshot.data()["artist"],
        isFavorite = false;

  static fromMap(Map maps, String id) {
    final List<Link> links = [];
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
            : [],
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
