import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Heart {
  final String id;

  Heart({this.id});
}

class Hearts with ChangeNotifier {
  static const String FAVORITES_KEY = "Favorites";

  List<String> _items = [];

  Hearts();

  List<String> get items {
    return [..._items];
  }

  void addHeart(String item) {
    _items.add(item);
    _save();
    notifyListeners();
  }

  void removeHeart(String item) {
    _items.remove(item);
    _save();
    // repository.remove(item);
    notifyListeners();
  }

  /// use those references to fill [_favorites].
  Future fetchHearts() async {
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
