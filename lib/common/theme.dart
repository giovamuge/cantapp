// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

//Colors for theme
final Color lightPrimary = Color(0xfffcfcff);
final Color darkPrimary = Colors.black;
final Color lightSecondary = Color(0xFF003049);
final Color lightAccent = Color(0xfff77f00);
final Color darkAccent = Color(0xfff77f00); //Colors.orangeAccent;
final Color lightBG = Color(0xfffcfcff);
final Color darkBG = Colors.black;

final appTheme = ThemeData.light().copyWith(
  // primarySwatch: Colors.yellow,
  primaryColorLight: lightAccent,
  primaryIconTheme: IconThemeData(color: darkPrimary),
  accentColor: lightAccent,
  accentColorBrightness: Brightness.light,
  backgroundColor: lightBG,
  primaryColor: darkPrimary,
  cursorColor: lightAccent,
  scaffoldBackgroundColor: lightBG,
  appBarTheme: AppBarTheme(
    elevation: 0,
    color: lightBG,
    brightness: Brightness.light,
    textTheme:
        TextTheme(headline6: TextStyle(color: Colors.black, fontSize: 18.0)),
  ),
);

final appThemeDark = ThemeData.dark().copyWith(
  primaryColorDark: lightAccent,
  accentColor: lightAccent,
  buttonColor: Colors.grey,
  accentColorBrightness: Brightness.dark,
  primaryIconTheme: IconThemeData(color: Colors.white),
  backgroundColor: darkBG,
  primaryColor: Colors.white,
  cursorColor: lightAccent,
  scaffoldBackgroundColor: darkBG,
  appBarTheme: AppBarTheme(
    elevation: 0,
    color: darkBG,
    brightness: Brightness.dark,
    textTheme:
        TextTheme(headline6: TextStyle(color: Colors.white, fontSize: 18.0)),
  ),
);

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;
  String _themeName;

  ThemeChanger(ThemeData themeData, String themeName)
      : _themeData = themeData,
        _themeName = themeName;

  getTheme() => _themeData;

  setTheme(ThemeData value, String name) {
    _themeData = value;
    _themeName = name;
    notifyListeners();
  }

  getThemeName() => _themeName;

  setThemeName(String value) {}
}

// Alternativa da valutare
// enum ThemeState { light, dark }

// class ThemeSwitch with ChangeNotifier {
//   ThemeSwitch(this._themeState);

//   ThemeState _themeState;
//   ThemeData _theme;

//   ThemeState get themeState => _themeState;
//   ThemeData get theme => _theme;

//   set themeState(ThemeState themeState) {
//     _themeState = themeState;

//     if (_themeState == ThemeState.light) {
//       _theme = ThemeData.light();
//     } else {
//       _theme = ThemeData.dark();
//     }
//     notifyListeners();
//     print("theme state changed");
//   }
// }
