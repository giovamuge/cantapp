import 'dart:math';

import 'package:cantapp/category/category_screen.dart';
import 'package:cantapp/favorite/favorite_screen.dart';
import 'package:cantapp/home/home_screen.dart';
import 'package:cantapp/setting/setting_screen.dart';
import 'package:cantapp/widgets/navbar_bottom.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedNavIndex = 0;
  List<Widget> _viewsByIndex;

  @override
  void initState() {
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
