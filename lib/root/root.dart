import 'package:cantapp/root/root_tablet.dart';
import 'package:flutter/material.dart';

import '../responsive/screen_type_layout.dart';
import 'root_mobile.dart';

// class RootScreen extends StatefulWidget {
//   @override
//   _RootScreenState createState() => _RootScreenState();
// }

// class _RootScreenState extends State<RootScreen> {
class RootScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: RootScreenMobile(),
      tablet: RootScreenTablet(),
    );
  }
}
