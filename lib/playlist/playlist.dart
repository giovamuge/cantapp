import 'package:flutter/material.dart';

class Playlist {
  final int index;
  final Color color;
  final String title;
  final String assetsImage;

  const Playlist({
    @required this.index,
    @required this.color,
    @required this.title,
    this.assetsImage,
  });

  @override
  String toString() {
    return 'Favorite { index: $index, color: $color, title: $title, assetsImage: $assetsImage }';
  }
}
