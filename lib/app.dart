import 'dart:math';

import 'package:cantapp/category/category_screen.dart';
import 'package:cantapp/favorite/favorite_screen.dart';
import 'package:cantapp/home/home_screen.dart';
import 'package:cantapp/widgets/navbar_bottom.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedNavIndex = 0;
  List<Widget> _viewsByIndex;
  String _currentTab = "/home";
  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "/home": GlobalKey<NavigatorState>(),
    "/categories": GlobalKey<NavigatorState>(),
    "/favorites": GlobalKey<NavigatorState>(),
    "/settings": GlobalKey<NavigatorState>(),
  };

  void _selectTab(String tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  void _handleNavBtnTapped(int index) {
    //Save the new index and trigger a rebuild
    setState(() {
      //This will be passed into the NavBar and change it's selected state, also controls the active content page
      _selectedNavIndex = index;
    });
  }

  @override
  void initState() {
    //Declare some buttons for our tab bar

    //Create the views which will be mapped to the indices for our nav btns
    _viewsByIndex = <Widget>[
      HomeScreen(),
      CategoryScreen(),
      FavoriteScreen(),
      Container(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Display the correct child view for the current index
    var contentView =
        _viewsByIndex[min(_selectedNavIndex, _viewsByIndex.length - 1)];
    //Wrap our custom navbar + contentView with the app Scaffold

    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab].currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != "/home") {
            // select 'main' tab
            _selectTab("/home");
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator("/home"),
          _buildOffstageNavigator("/categories"),
          _buildOffstageNavigator("/favorites"),
          _buildOffstageNavigator("/settings"),
        ]),
        bottomNavigationBar: NavbarBottomWidget(
          itemTapped: _handleNavBtnTapped,
          currentIndex: _selectedNavIndex,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(String tabItem) {
    // build routes
    final routeBuilders = _routeBuilders(context);

    return Offstage(
      offstage: _currentTab != tabItem,
      child: Navigator(
        key: _navigatorKeys[tabItem],
        initialRoute: TabNavigatorRoutes.home,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }

  void _push(BuildContext context, {int materialIndex: 500}) {
    var routeBuilders = _routeBuilders(context, materialIndex: materialIndex);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            routeBuilders[TabNavigatorRoutes.categories](context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context,
      {int materialIndex: 500}) {
    return {
      TabNavigatorRoutes.home: (context) => HomeScreen(),
      TabNavigatorRoutes.categories: (context) => CategoryScreen(),
      TabNavigatorRoutes.favorites: (context) => FavoriteScreen(),
      TabNavigatorRoutes.home: (context) => HomeScreen(),
      TabNavigatorRoutes.home: (context) => HomeScreen(),
      // TabNavigatorRoutes.root: (context) => ColorsListPage(
      //       color: activeTabColor[tabItem],
      //       title: tabName[tabItem],
      //       onPush: (materialIndex) =>
      //           _push(context, materialIndex: materialIndex),
      //     ),
      // TabNavigatorRoutes.detail: (context) => ColorDetailPage(
      //       color: activeTabColor[tabItem],
      //       title: tabName[tabItem],
      //       materialIndex: materialIndex,
      //     ),
    };
  }
}

class TabNavigatorRoutes {
  static const String home = '/home';
  static const String categories = '/categories';
  static const String favorites = '/favorites';
  static const String settings = '/settings';
}
