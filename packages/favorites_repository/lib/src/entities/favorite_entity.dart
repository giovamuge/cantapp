// import 'favorite_entity.dart';

// class FavoriteEntity {
//   final String songId;
//   final DocumentReference song;
//   final DateTime updatedAt;
//   final DateTime createdAt;
//   final String id;

//   const FavoriteEntity(
//       {this.songId, this.song, this.createdAt, this.updatedAt, this.id});

//   FavoriteEntity.fromMap(Map maps, String documentId)
//       : id = documentId,
//         songId = maps["songId"],
//         song = maps["song"],
//         updatedAt = null,
//         createdAt = null;

//   // static fromMap(Map maps, String documentId) {
//   //   if (maps["createdAt"]) {
//   //     final data = Timestamp.fromDate(maps["createdAt"]);
//   //   }
//   //   // timeago.format(firestoreTime.toDate());

//   //   return FavoriteFire(id: maps["id"], songId: maps["songId"]);
//   // }

//   toJson() => {
//         "id": this.id,
//         "songId": this.songId,
//         "createdAt": this.createdAt,
//         "updatedAt": this.updatedAt,
//         "song": this.song
//       };
// }
