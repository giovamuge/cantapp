import 'dart:math';

import 'package:cantapp/category/category_screen.dart';
import 'package:cantapp/favorite/favorite_screen.dart';
import 'package:cantapp/home/home_screen.dart';
import 'package:cantapp/playlist/playlist.dart';
import 'package:cantapp/playlist/playlist_screen.dart';
import 'package:cantapp/setting/setting_screen.dart';
import 'package:cantapp/widgets/navbar_bottom.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  int _selectedNavIndex = 0;
  List<Widget> _viewsByIndex;

  // TabController _controller;

  @override
  void initState() {
    //Create the views which will be mapped to the indices for our nav btns
    _viewsByIndex = <Widget>[
      HomeScreen(),
      CategoryScreen(),
      FavoriteScreen(),
      SettingScreen(),
      PlaylistScreen()
    ];
    // _controller = TabController(
    //     length: _viewsByIndex.length, initialIndex: 0, vsync: this);
    // _controller.addListener(_onTabChanges);
    super.initState();
  }

  @override
  void dispose() {
    // _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Display the correct child view for the current index
    var contentView =
        _viewsByIndex[min(_selectedNavIndex, _viewsByIndex.length - 1)];
    //Wrap our custom navbar + contentView with the app Scaffold
    return Scaffold(
      // without tab controller
      // maybe is small large ram but every time
      // rebuild the widget (page_screen)

      body: Container(
        width: double.infinity,
        //Wrap the current page in an AnimatedSwitcher for an easy cross-fade effect
        child: contentView,
      ),
      // body: TabBarView(
      //   children: _viewsByIndex,
      //   controller: _controller,
      // ),
      bottomNavigationBar: NavbarBottomWidget(
        itemTapped: _handleNavBtnTapped,
        currentIndex: _selectedNavIndex,
      ),
    );
  }

  void _handleNavBtnTapped(int index) {
    //Save the new index and trigger a rebuild
    setState(() {
      //This will be passed into the NavBar and change it's selected state, also controls the active content page
      _selectedNavIndex = index;
    });

    // _controller.animateTo(index);
  }

  // void _onTabChanges() {
  //   setState(() => _selectedNavIndex = _controller.index);
  // }
}
