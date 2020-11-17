import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> navigatorTabletKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateTabletTo(String routeName, {dynamic arguments}) {
    return navigatorTabletKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }

  void goBack() {
    return navigatorKey.currentState.pop();
  }

  void goTabletBack() {
    return navigatorKey.currentState.pop();
  }
}
