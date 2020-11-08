import 'package:cantapp/root/root.dart';
import 'package:cantapp/song/song_screen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> appRoutes = {
  // Export static map routes
  // '/' to tab screen
  // '/song' detail song with lyric
  '/': (context) => RootScreen(),
  '/song': (context) => SongScreen(id: '')
};
