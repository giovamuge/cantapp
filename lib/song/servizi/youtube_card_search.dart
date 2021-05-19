import 'package:cantapp/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class YouTubeCardSearch extends StatelessWidget {
  final double _heigth;
  final String _url;

  const YouTubeCardSearch({@required double heigth, @required String url})
      : _heigth = heigth,
        _url = url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        customBorder: Border.all(color: Colors.black, width: 10),
        radius: 10,
        onTap: () => Utils.launchURL(_url),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Theme.of(context).dialogBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.youtube, size: 35),
                SizedBox(height: 5),
                Text(
                  "Per cercare su YouTube\n clicca qui",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
