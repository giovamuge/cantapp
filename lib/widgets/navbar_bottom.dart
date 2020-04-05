import 'package:cantapp/common/theme.dart';
import 'package:flutter/material.dart';

class NavbarBottomWidget extends StatelessWidget {
  final ValueChanged<int> _itemTapped;
  final int _currentIndex;
  final Color _splashColor = Colors.yellow[100];
  final Color _highlightColor = Colors.yellow[50];

  NavbarBottomWidget(
      {@required ValueChanged<int> itemTapped, @required int currentIndex})
      : _currentIndex = currentIndex,
        _itemTapped = itemTapped;

  @override
  Widget build(BuildContext context) {
    return Material(
      // padding: const EdgeInsets.symmetric(vertical: 5.0),
      // decoration: BoxDecoration(
      //   // color: Colors.yellow,
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black,
      //       blurRadius: 15.0, // has the effect of softening the shadow
      //       offset: Offset(
      //         0, // horizontal, move right 10
      //         20, // vertical, move down 10
      //       ),
      //     )
      //   ],
      //   color: Colors.white,
      //   borderRadius: BorderRadius.only(
      //     topLeft: Radius.circular(35),
      //     topRight: Radius.circular(35),
      //   ),
      // ),
      color: lightBG,
      elevation: 15, // oppure 5 o 1
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(35),
        topRight: Radius.circular(35),
      ),
      child: Padding(
        // padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom, top: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
                splashColor: _splashColor,
                highlightColor: _highlightColor,
                icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0 ? Colors.yellow : Colors.grey,
                ),
                onPressed: () => _itemTapped(0)),
            IconButton(
                splashColor: _splashColor,
                highlightColor: _highlightColor,
                icon: Icon(Icons.dashboard,
                    color: _currentIndex == 1 ? Colors.yellow : Colors.grey),
                onPressed: () => _itemTapped(1)),
            IconButton(
                splashColor: _splashColor,
                highlightColor: _highlightColor,
                icon: Icon(Icons.favorite,
                    color: _currentIndex == 2 ? Colors.yellow : Colors.grey),
                onPressed: () => _itemTapped(2)),
            IconButton(
                splashColor: _splashColor,
                highlightColor: _highlightColor,
                icon: Icon(Icons.settings,
                    color: _currentIndex == 3 ? Colors.yellow : Colors.grey),
                onPressed: () => _itemTapped(3))
          ],
        ),
      ),
    );
  }
}
