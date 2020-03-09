import 'package:flutter/foundation.dart';

class Heart {
  final String id;

  Heart({this.id});
}

class Hearts with ChangeNotifier {
  List<String> _items = [];

  List<String> get items {
    return [..._items];
  }

  void addHeart(String item) {
    _items.add(item);
    notifyListeners();
  }

  void removeHeart(String item) {
    _items.remove(item);
    notifyListeners();
  }
}
