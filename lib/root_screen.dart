import 'dart:math';

import 'package:cantapp/category/category_screen.dart';
import 'package:cantapp/favorite/favorite_screen.dart';
import 'package:cantapp/home/home_screen.dart';
import 'package:cantapp/setting/setting_screen.dart';
import 'package:cantapp/widgets/navbar/navbar.dart';
import 'package:cantapp/widgets/navbar_bottom.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  List<NavBarItemData> _navBarItems;
  int _selectedNavIndex = 0;
  List<Widget> _viewsByIndex;

  @override
  void initState() {
    //Declare some buttons for our tab bar
    _navBarItems = [
      NavBarItemData("Home", Icons.home, 110, Color(0xFFF3DFBF)),
      NavBarItemData("Categoria", Icons.dashboard, 110, Color(0xFFF3DFBF)),
      NavBarItemData("Preferiti", Icons.favorite, 115, Color(0xFFF3DFBF)),
      NavBarItemData("Settings", Icons.settings, 100, Color(0xFFF3DFBF)),
    ];

    //Create the views which will be mapped to the indices for our nav btns
    _viewsByIndex = <Widget>[
      HomeScreen(),
      CategoryScreen(),
      FavoriteScreen(),
      SettingScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var accentColor = _navBarItems[_selectedNavIndex].selectedColor;

    //Create custom navBar, pass in a list of buttons, and listen for tap event
    var navBar = NavBar(
      items: _navBarItems,
      itemTapped: _handleNavBtnTapped,
      currentIndex: _selectedNavIndex,
    );
    //Display the correct child view for the current index
    var contentView =
        _viewsByIndex[min(_selectedNavIndex, _viewsByIndex.length - 1)];
    //Wrap our custom navbar + contentView with the app Scaffold
    return Scaffold(
      // backgroundColor: Color(0xffE6E6E6),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          //Wrap the current page in an AnimatedSwitcher for an easy cross-fade effect
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 350),
            //Pass the current accent color down as a theme, so our overscroll indicator matches the btn color
            child: contentView,
          ),
        ),
      ),
      // bottomNavigationBar: navBar, //Pass our custom navBar into the scaffold
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
  }
}
