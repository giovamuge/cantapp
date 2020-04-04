import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorite {
  final String id;

  Favorite({this.id});
}

class Favorites with ChangeNotifier {
  static const String FAVORITES_KEY = "Favorites";

  List<String> _items = [];

  Favorites();

  List<Object> get props => [_items];

  @override
  String toString() {
    return 'Favorite { items: $_items }';
  }

  List<String> get items {
    return [..._items];
  }

  void addFavorite(String item) {
    _items.add(item);
    _save();
    notifyListeners();
  }

  void removeFavorite(String item) {
    _items.remove(item);
    _save();
    // repository.remove(item);
    notifyListeners();
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
  bool exist(String id) {
    return _items.any((f) => f == id);
  }

  /// Persists the data to disk.
  _save() {
    SharedPreferences.getInstance().then((SharedPreferences prefs) =>
        prefs.setStringList(FAVORITES_KEY, _items));
  }
}
