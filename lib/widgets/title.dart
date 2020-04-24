import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String _title;
  final EdgeInsetsGeometry _padding;

  const TitleWidget(
    String title, {
    Key key,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 15),
  })  : _title = title,
        _padding = padding;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: _padding,
        alignment: Alignment.centerLeft,
        child: Text(_title, style: TextStyle(fontSize: 50)));
  }
}
