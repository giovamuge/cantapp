// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

//Colors for theme
final Color lightPrimary = Color(0xfffcfcff);
final Color darkPrimary = Colors.black;
final Color lightAccent = Colors.yellow;
final Color darkAccent = Colors.orangeAccent;
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
    textTheme: TextTheme(title: TextStyle(color: Colors.black, fontSize: 18.0)),
  ),
);

final appThemeDark = ThemeData.dark().copyWith(
  primaryColorDark: lightAccent,
  accentColor: lightAccent,
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
    textTheme: TextTheme(title: TextStyle(color: Colors.white, fontSize: 18.0)),
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
