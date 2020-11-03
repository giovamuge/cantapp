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

class Favorites with ChangeNotifier {
  static const String FAVORITES_KEY = "Favorites";

  List<String> _items = [];

  Favorites() {
    // esegue un fetch dei preferiti
    // quando viene istanziata la classe
    fetchFavorites();
  }

  List<Object> get props => [_items];

  @override
  String toString() => 'Favorite { items: $_items }';

  List<String> get items {
    return [..._items];
  }

  Future<void> addFavorite(String item) async {
    final firestore = GetIt.instance<FirestoreDatabase>();
    final newFavorite = FavoriteFire(
      createdAt: DateTime.now(),
      songId: item,
      song: Firestore.instance.document(FirestorePath.song(item)),
    );
    await firestore.addFavorite(newFavorite);
    // notifyListeners();
  }

  Future<void> removeFavorite(String favroiteId) async {
    final firestore = GetIt.instance<FirestoreDatabase>();
    await firestore.removeFavorite(favroiteId);
  }

  /// use those references to fill [_favorites].
  Future fetchFavorites() async {
    // ottieni i dati nelle preferenze
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // carica preferiti se non è null
    // imposta un array vuoto []
    _items = prefs.getStringList(FAVORITES_KEY) ?? [];
    notifyListeners();
  }

  /// if exist heart in items
  Future<bool> exist(String id) async {
    // return _items.any((f) => f == id);
    final firestore = GetIt.instance<FirestoreDatabase>();
    return await firestore.favoriteStream(id).isEmpty;
  }

  /// Persists the data to disk.
  _save() {
    SharedPreferences.getInstance().then((SharedPreferences prefs) =>
        prefs.setStringList(FAVORITES_KEY, _items));
  }
}
