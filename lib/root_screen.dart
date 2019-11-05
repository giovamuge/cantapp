import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cantapp/category/category_screen.dart';
import 'package:cantapp/favorite/favorite_screen.dart';
import 'package:cantapp/home/home_screen.dart';
import 'package:flutter/material.dart';

class RootModel {
  final Widget page;
  final IconData icon;
  final String title;

  const RootModel({this.page, this.icon, this.title});
}

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  TabController _tabController;
  List<RootModel> _roots;

  @override
  void initState() {
    _roots = _buildRoot(context);
    _tabController = TabController(vsync: this, length: _roots.length);
    super.initState();
  }

  List<RootModel> _buildRoot(BuildContext context) {
    return <RootModel>[
      RootModel(page: HomeScreen(), title: "Home", icon: Icons.home),
      RootModel(
          page: CategoryScreen(), title: "Cateogria", icon: Icons.dashboard),
      RootModel(
          page: FavoriteScreen(), title: "Preferiti", icon: Icons.favorite),
      RootModel(page: Container(), title: "Setting", icon: Icons.settings)
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _tabController.animateTo(_selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: _roots.map((root) => root.page).toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        // fabLocation: BubbleBottomBarFabLocation.end, //new
        hasNotch: true, //new
        hasInk: true, //new, gives a cute ink effect
        inkColor: Colors.black12, //optional, uses theme color if not specified
        items: _roots
            .map(
              (root) => BubbleBottomBarItem(
                  backgroundColor: Colors.blueGrey[400],
                  icon: Icon(root.icon, color: Colors.black),
                  activeIcon: Icon(root.icon, color: Colors.blueGrey),
                  title: Text(root.title)),
            )
            .toList(),
      ),
    );
  }
}
