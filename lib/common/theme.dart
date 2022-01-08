// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final appTheme = ThemeData.light().copyWith(
  // primarySwatch: Colors.yellow,
  primaryColorLight: AppTheme.accent,
  primaryIconTheme: IconThemeData(color: AppTheme.primaryDark),
  colorScheme: ThemeData.light()
      .colorScheme
      .copyWith(secondary: AppTheme.accent, brightness: Brightness.light),
  backgroundColor: AppTheme.background,
  primaryColor: AppTheme.primaryDark,
  textSelectionTheme: ThemeData.light()
      .textSelectionTheme
      .copyWith(cursorColor: AppTheme.accent),
  scaffoldBackgroundColor: AppTheme.background,
  appBarTheme: AppBarTheme(
      elevation: 0,
      color: AppTheme.background,
      foregroundColor: AppTheme.primaryDark,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(color: AppTheme.primaryDark, fontSize: 18.0)),
);

final appThemeDark = ThemeData.dark().copyWith(
  primaryColorDark: AppTheme.accent,
  colorScheme: ThemeData.dark()
      .colorScheme
      .copyWith(secondary: AppTheme.accent, brightness: Brightness.dark),
  // buttonColor: Colors.grey,
  primaryIconTheme: IconThemeData(color: Colors.white),
  backgroundColor: AppTheme.backgroundDark,
  primaryColor: Colors.white,
  textSelectionTheme: ThemeData.light()
      .textSelectionTheme
      .copyWith(cursorColor: AppTheme.accent),
  scaffoldBackgroundColor: AppTheme.backgroundDark,
  appBarTheme: AppBarTheme(
    elevation: 0,
    color: AppTheme.backgroundDark,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    foregroundColor: AppTheme.primary,
    titleTextStyle: TextStyle(color: AppTheme.primary, fontSize: 18.0),
  ),
);

// examples theme
// theme: ThemeData(
//           primaryColor: AppTheme.primary,
//           primaryColorDark: AppTheme.primaryDark,
//           accentColor: AppTheme.accent,
//           textTheme: GoogleFonts.acmeTextTheme().copyWith(
//               button: GoogleFonts.ubuntuMono(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               )),

class AppTheme {
  static const Color primary = Color(0xfffcfcff);
  static const Color primaryDark = Color(0xff000000);
  static const Color secondary = Color(0xFF003049);
  static const Color accent = Color(0xfff77f00);
  static const Color accentDark = Color(0xfff77f00);
  static const Color background = Color(0xfffcfcff);
  static const Color backgroundDark =
      Color(0xff000000); // TODO: potrebbe anche essere Color(0xFF003049)
}

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
