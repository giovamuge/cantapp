// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

final appTheme = ThemeData(
  primarySwatch: Colors.yellow,
  textTheme: TextTheme(
    display4: TextStyle(
      fontFamily: 'Corben',
      fontWeight: FontWeight.w700,
      fontSize: 24,
      color: Colors.black,
    ),
  ),
);

// final appTheme = ThemeData(
//     // This is the theme of your application.
//     //
//     // Try running your application with "flutter run". You'll see the
//     // application has a blue toolbar. Then, without quitting the app, try
//     // changing the primarySwatch below to Colors.green and then invoke
//     // "hot reload" (press "r" in the console where you ran "flutter run",
//     // or simply save your changes to "hot reload" in a Flutter IDE).
//     // Notice that the counter didn't reset back to zero; the application
//     // is not restarted.
//     primaryColor: Color(0xFF355070),
//     backgroundColor: Color(0xFF355070),
//     colorScheme: Theme.of(context).colorScheme.copyWith(
//           primary: Color(0xF355070),
//           primaryVariant: Color(0xFF2D82B7),
//           secondary: Color(0xFFB56576),
//           secondaryVariant: Color(0xFFEB8A90),
//         ),
//     textTheme: TextTheme(
//       body1: TextStyle(color: Color(0xFFB56576)),
//     ),
//     platform: Theme.of(context).platform
//     // primaryColor: Colors.blue
//     );
