import 'package:flutter/material.dart';

class NavbarBottomWidget extends StatelessWidget {
  final ValueChanged<int> _itemTapped;
  final int _currentIndex;

  const NavbarBottomWidget(
      {@required ValueChanged<int> itemTapped, @required int currentIndex})
      : _currentIndex = currentIndex,
        _itemTapped = itemTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        // color: Colors.yellow,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 15.0, // has the effect of softening the shadow
            offset: Offset(
              0, // horizontal, move right 10
              20, // vertical, move down 10
            ),
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.home,
                color: _currentIndex == 0 ? Colors.yellow : Colors.grey,
              ),
              onPressed: () => _itemTapped(0)),
          IconButton(
              icon: Icon(Icons.dashboard,
                  color: _currentIndex == 1 ? Colors.yellow : Colors.grey),
              onPressed: () => _itemTapped(1)),
          IconButton(
              icon: Icon(Icons.favorite,
                  color: _currentIndex == 2 ? Colors.yellow : Colors.grey),
              onPressed: () => _itemTapped(2)),
          IconButton(
              icon: Icon(Icons.settings,
                  color: _currentIndex == 3 ? Colors.yellow : Colors.grey),
              onPressed: () => _itemTapped(3))
        ],
      ),
    );
  }
}
