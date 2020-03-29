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

  @override
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _items = prefs.getStringList(FAVORITES_KEY);
    notifyListeners();
  }

  /// if exist heart in items
  bool exist(String id) {
    return _items.any((f) => f == id);
  }

  /// Persists the data to disk.
  _save() {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setStringList(FAVORITES_KEY, _items);
    });
  }
}
