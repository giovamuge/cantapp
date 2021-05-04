import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BadgetWidget extends StatelessWidget {
  final String title;
  final Color color;

  const BadgetWidget({Key key, required this.color, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeChanger>(context, listen: false);

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: color,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          color: theme.getThemeName() == Constants.themeLight
              ? AppTheme.background
              : AppTheme.backgroundDark,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
