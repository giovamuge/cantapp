import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  String id;
  String title;
  String lyric;
  bool isFavorite = false;

  Song(this.title, this.lyric);

  Song.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.documentID,
        title = snapshot.data["title"],
        lyric = snapshot.data["lyric"];

  Song.formMap(Map maps, String id)
      : id = id,
        title = maps["title"],
        lyric = maps["lyric"];

  toJson() {
    return {
      "id": id,
      "title": title,
      "lyric": lyric,
    };
  }
}
