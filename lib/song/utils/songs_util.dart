import 'package:cantapp/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/theme.dart';

class SongUtils {
  static Widget buildLoader() {
    return Consumer<ThemeChanger>(
      builder: (context, theme, child) {
        return Shimmer.fromColors(
          // baseColor: Theme.of(context).primaryColorLight,
          // highlightColor: Theme.of(context).primaryColor,
          baseColor: theme.getThemeName() == Constants.themeLight
              ? Colors.grey[100]
              : Colors.grey[600],
          highlightColor: theme.getThemeName() == Constants.themeLight
              ? Colors.grey[300]
              : Colors.grey[900],
          child: child,
        );
      },
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Container(
              width: 35.00,
              height: 35.00,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.white,
              ),
            ),
            title: Container(
              width: MediaQuery.of(context).size.width - 35.00,
              height: 30.00,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.white,
              ),
            ),
          );
        },
        itemCount: List.generate(15, (i) => i++).length,
      ),
    );
  }
}
