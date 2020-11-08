import 'package:flutter/material.dart';

class NavigatorTablet with ChangeNotifier {
  Widget _view;
  Widget get view => _view;

  set view(Widget data) {
    _view = data;
    notifyListeners();
  }
}
