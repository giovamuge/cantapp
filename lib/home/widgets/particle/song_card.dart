import 'package:cantapp/song/song_model.dart';
import 'package:flutter/material.dart';

import 'package:cantapp/main.dart';
import 'swipe_item.dart';

// Content for the list items.
class SongCard extends StatelessWidget {
  final Song song;
  final Color backgroundColor;

  SongCard({this.song, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Container(
        width: w + 0.1,
        height: SwipeItem.nominalHeight,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: Colors.black.withOpacity(0.5),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                if (song.isFavorite)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.lens, size: 12.0, color: Color(0xffaa07de)),
                  ),
                Expanded(
                  child:
                      Text(song.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: .3, package: MyApp.pkg)),
                ),
                Text('11:45 PM', style: TextStyle(fontSize: 11, letterSpacing: .3, package: MyApp.pkg)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("prova", style: TextStyle(fontSize: 11, letterSpacing: .3, package: MyApp.pkg)),
                if (song.isFavorite) Icon(Icons.star, size: 18.0, color: Color(0xff55c8d4)),
              ],
            ),
            SizedBox(height: 2.0),
            Text(
              "body",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, letterSpacing: .3, color: Color(0xff9293bf), package: MyApp.pkg),
            ),
            SizedBox(
              width: 16.0,
            ),
          ],
        ));
  }
}
