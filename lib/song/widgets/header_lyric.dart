import 'package:cantapp/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:cantapp/extensions/string.dart';

class HeaderLyric extends StatelessWidget {
  final List<String> categories;
  final String title;
  final String artist;
  final String number;

  const HeaderLyric({
    required this.title,
    required this.number,
    this.categories,
    this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // disegna se esistono le cateogire
        if (categories != null && categories.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._buildCategories(categories),
            ],
          ),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            // fontSize: lyricData.fontSize * 1.25,
            fontSize: 35,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xFF48639C), //_avatarColor[100]
              ),
              child: Center(
                child: Text(
                  '$number',
                  style: TextStyle(
                      color: Color(0xFFFFFFFF), //_avatarColor[900],
                      fontWeight: FontWeight.w800,
                      fontSize: 11),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              artist.isNullOrEmpty() ? "Artista sconosciuto" : artist,
              style: TextStyle(
                // fontSize: lyricData.fontSize * 1.25,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).primaryColor.withOpacity(.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildCategories(List<String> categories) {
    var index = 0;
    return categories.map(
      (cat) {
        final double paddingLeft = index == 0 ? 5 : 0;
        final double paddingRight = index == categories.length - 1 ? 5 : 0;
        index++;
        return Container(
          height: 20,
          padding: EdgeInsets.only(left: paddingLeft, right: paddingRight),
          child: RaisedButton(
            color: AppTheme.accent,
            child: Text(
              // Categories.items
              //     .where((x) => x.value.toString() == cat)
              //     .single
              //     .title,
              cat,
              style: TextStyle(color: AppTheme.background, fontSize: 13),
            ),
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            onPressed: () {
              // TODO: naviga vero la categoria con la lista delle canzoni
            },
          ),
        );
      },
    ).toList();
  }
}
