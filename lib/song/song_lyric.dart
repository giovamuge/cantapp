import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongLyric with ChangeNotifier {
  // key for shared prefernces
  static const String FONTSIZE_KEY = "fontSizee";
  static const double _defaultSize = 15.00;

  double _fontSize;
  double get fontSize {
    return _fontSize;
  }

  bool _isCollasped = false;
  bool get isCollasped => _isCollasped;
  set isCollasped(bool value) => _isCollasped = value;

  set fontSize(double value) {
    _fontSize = value;
    _save().then((_) => print('font size saved: $_fontSize'));
    notifyListeners();
  }

  SongLyric({double fontSize}) {
    _fontSize = fontSize;
    _load().then((_) => print('font size loaded: $_fontSize'));
  }

  // Save persists the data to disk.
  Future _save() async => SharedPreferences.getInstance().then(
      (SharedPreferences prefs) => prefs.setDouble(FONTSIZE_KEY, _fontSize));

  // Load persists the data to disk.
  Future _load() async {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      _fontSize = prefs.getDouble(FONTSIZE_KEY) ?? _defaultSize;
      notifyListeners();
    });
  }

  void collaspe() {
    _isCollasped = !_isCollasped;
    notifyListeners();
  }
}
