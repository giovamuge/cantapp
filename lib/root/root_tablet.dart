import 'package:cantapp/common/theme.dart';
import 'package:cantapp/root/navigator_tablet.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:cantapp/category/category_screen.dart';
import 'package:cantapp/favorite/favorite_screen.dart';
import 'package:cantapp/home/home_screen.dart';
import 'package:cantapp/playlist/playlist_screen.dart';
import 'package:cantapp/setting/setting_screen.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RootScreenTablet extends StatefulWidget {
  @override
  _RootScreenTabletState createState() => _RootScreenTabletState();
}

class _RootScreenTabletState extends State<RootScreenTablet>
    with TickerProviderStateMixin {
  int _selectedNavIndex = 0;
  List<Widget> _viewsByIndex;
  GlobalKey<NavigatorState> _navKey;
  RouteObserver _routeObserver;
  List<String> _navStack;

  @override
  void initState() {
    super.initState();
    _navKey = GlobalObjectKey<NavigatorState>(this);
    _navStack = [];
    _routeObserver = RouteObserver();
    //Create the views which will be mapped to the indices for our nav btns
    _viewsByIndex = <Widget>[
      HomeScreen(),
      CategoryScreen(),
      FavoriteScreen(),
      SettingScreen(),
      PlaylistScreen()
    ];
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    // _controller?.dispose();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Display the correct child view for the current index
    final Widget contentView =
        _viewsByIndex[min(_selectedNavIndex, _viewsByIndex.length - 1)];
    //Wrap our custom navbar + contentView with the app Scaffold
    return Scaffold(
      // without tab controller
      // maybe is small large ram but every time
      // rebuild the widget (page_screen)

      body: SafeArea(
        child: Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.07,
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  left: MediaQuery.of(context).padding.bottom,
                  right: 5.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(Icons.home,
                            color: _selectedNavIndex == 0
                                ? lightAccent
                                : Colors.grey),
                        onPressed: () => _handleNavBtnTapped(0)),
                    // IconButton(
                    //   icon: Icon(Icons.dashboard,
                    //       color: _selectedNavIndex == 1
                    //           ? lightAccent
                    //           : Colors.grey),
                    //   onPressed: () => _handleNavBtnTapped(1),
                    // ),
                    IconButton(
                        icon: Icon(Icons.favorite,
                            color: _selectedNavIndex == 2
                                ? lightAccent
                                : Colors.grey),
                        onPressed: () => _handleNavBtnTapped(2)),
                    IconButton(
                        icon: Icon(Icons.featured_play_list,
                            color: _selectedNavIndex == 4
                                ? lightAccent
                                : Colors.grey),
                        onPressed: () => _handleNavBtnTapped(4)),
                    IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: _selectedNavIndex == 3
                              ? lightAccent
                              : Colors.grey,
                        ),
                        onPressed: () => _handleNavBtnTapped(3)),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.40,
              height: MediaQuery.of(context).size.height,
              child: contentView,
            ),
            Consumer<NavigatorTablet>(
              builder: (context, navigator, child) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.53,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                          color: Theme.of(context).dialogBackgroundColor,
                          width: 5),
                    ),
                  ),
                  child: navigator.view,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Route<R> _buildRoute<R>(WidgetBuilder builder, String name) {
    return MaterialPageRoute(
        builder: builder, settings: RouteSettings(name: name));
  }

  void _handleNavBtnTapped(int index) {
    //Save the new index and trigger a rebuild
    setState(() =>
        //This will be passed into the NavBar and change it's selected state, also controls the active content page
        _selectedNavIndex = index);

    Provider.of<NavigatorTablet>(context, listen: false).view = Container();

    // _controller.animateTo(index);
  }
}
