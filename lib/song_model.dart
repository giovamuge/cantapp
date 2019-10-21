import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  String id;
  String title;
  String lyric;
  bool isFavorite = false;
  List<dynamic> categories;

  Song(this.title, this.lyric);

  Song.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.documentID,
        title = snapshot.data["title"],
        lyric = snapshot.data["lyric"],
        categories = snapshot.data["categories"] != null
            ? new List<String>.from(snapshot.data["categories"])
            : null;

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
}
