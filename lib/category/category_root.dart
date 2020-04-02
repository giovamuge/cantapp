import 'package:cantapp/category/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoryRoot extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: "/categories",
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
            maintainState: true, builder: (ctx) => CategoryScreen());
      },
    );
  }
}
