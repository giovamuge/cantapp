import 'package:cantapp/song/utils/lyric_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LyricWidget extends StatelessWidget {
  final String _text;
  final double _fontSize;
  final Widget _child;

  const LyricWidget({
    Key key,
    required String text,
    required double fontSize,
    Widget child,
  })  : _fontSize = fontSize,
        _text = text,
        _child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [...LyricUtil().buildLyric(context, _text, _fontSize, _child)],
    );
  }
}
