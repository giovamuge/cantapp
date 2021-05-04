import 'package:cantapp/activity/activity_screen.dart';
import 'package:cantapp/common/theme.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class PlaylistCardWidget extends StatelessWidget {
  final int _index;
  final MaterialColor _color;
  final String _title;
  final String _assetsImage;
  final String _description;

  PlaylistCardWidget(
      {required int index,
      required MaterialColor color,
      required String title,
      required String assetsImage,
      String description = ""})
      : _title = title,
        _index = index,
        _color = color,
        _assetsImage = assetsImage,
        _description = description;

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = 150.00;

    return Container(
      margin: EdgeInsets.only(bottom: 25),
      // width: screenWidth,
      height: MediaQuery.of(context).size.width * 0.5,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withOpacity(0.5),
            spreadRadius: 2.5,
            blurRadius: 10,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            // transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (context, _, __) => ActivityScreen(
              index: _index,
              color: _color,
              title: _title,
            ),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Hero(
                tag: "background-$_index",
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [_color[200], _color[400]],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                ),
              ),
            ),
            // Container(
            //   alignment: Alignment.topRight,
            //   padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            //   child: Image(
            //     image: AssetImage("icons/music.png"),
            //     width: 75,
            //     height: 75,
            //   ),
            //   // child: SvgPicture.asset(_assetsImage,
            //   //   semanticsLabel: 'Popularity',
            //   //   height: 70,
            //   //   width: 70,
            //   // ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Hero(
                    tag: "name-$_index",
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        child: Text(_title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              // color: _color[800],
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 35,
                            )),
                      ),
                    ),
                  ),
                  Container(
                    child: _description == ""
                        ? SizedBox(height: 0)
                        : Text(_description,
                            style: TextStyle(color: _color[800])),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
