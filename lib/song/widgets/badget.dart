import 'package:flutter/material.dart';

class BadgetWidget extends StatelessWidget {
  final String title;
  final MaterialColor color;

  const BadgetWidget({
    Key key,
    @required this.color,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: color[100],
      ),
      child: Text(
        title,
        style: TextStyle(color: color[900], fontSize: 10),
        textAlign: TextAlign.center,
      ),
    );
  }
}
