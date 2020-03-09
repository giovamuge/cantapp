import 'dart:math';

import 'package:cantapp/category/category_screen.dart';
import 'package:cantapp/favorite/favorite_screen.dart';
import 'package:cantapp/favorite/heart.dart';
import 'package:cantapp/home/home_screen.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/widgets/navbar/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  List<NavBarItemData> _navBarItems;
  int _selectedNavIndex = 0;

  List<Widget> _viewsByIndex;

  final Firestore _databaseReference = Firestore.instance;

  @override
  void initState() {
    //Declare some buttons for our tab bar
    _navBarItems = [
      NavBarItemData("Home", Icons.home, 110, Color(0xff01b87d)),
      NavBarItemData("Categoria", Icons.dashboard, 110, Color(0xff594ccf)),
      NavBarItemData("Preferiti", Icons.favorite, 115, Color(0xff09a8d9)),
      NavBarItemData("Settings", Icons.settings, 100, Color(0xffcf4c7a)),
    ];

    //Create the views which will be mapped to the indices for our nav btns
    _viewsByIndex = <Widget>[
      // HomeScreen(),
      HomeScreen(),
      CategoryScreen(),
      FavoriteScreen(),
      Container(),
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
      backgroundColor: Color(0xffE6E6E6),
      body: MultiProvider(
        providers: getProviders(),
        child: SafeArea(
          child: Container(
            width: double.infinity,
            //Wrap the current page in an AnimatedSwitcher for an easy cross-fade effect
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 350),
              //Pass the current accent color down as a theme, so our overscroll indicator matches the btn color
              child: Theme(
                data: ThemeData(accentColor: accentColor),
                child: contentView,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: navBar, //Pass our custom navBar into the scaffold
    );
  }

  List<SingleChildWidget> getProviders() {
    return [
      ChangeNotifierProvider<Hearts>(create: (_) => Hearts()),
      ChangeNotifierProvider<Songs>(
          create: (_) => Songs(databaseReference: _databaseReference))
    ];
  }

  void _handleNavBtnTapped(int index) {
    //Save the new index and trigger a rebuild
    setState(() {
      //This will be passed into the NavBar and change it's selected state, also controls the active content page
      _selectedNavIndex = index;
    });
  }
}
