import 'package:cantapp/song/song_lyric.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SongFullScreen extends StatelessWidget {
  // @override
  // void initState() {
  //   super.initState();
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeRight,
  //     DeviceOrientation.landscapeLeft,
  //   ]);
  // }

  // @override
  // dispose() {
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeRight,
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  //   super.dispose();
  // }

  final String _title;
  final String _body;
  final Widget _child;
  const SongFullScreen(
      {@required String body, @required String title, Widget child})
      : _body = body,
        _title = title,
        _child = child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.compress),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.format_size),
            onPressed: () async => await _settingModalBottomSheet(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Consumer<SongLyric>(
          builder: (context, lyricData, child) {
            return Wrap(
              // alignment: WrapAlignment.start,
              // verticalDirection: VerticalDirection.down,
              // crossAxisAlignment: WrapCrossAlignment.start,
              direction: Axis.vertical,
              runSpacing: 25,
              spacing: 0,
              children: [
                Text(
                  _title,
                  style: TextStyle(
                    fontSize: lyricData.fontSize * 1.25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 20),
                ..._buildLyric(context, lyricData.fontSize),
              ],
            );
            // return Column(
            //   children: [..._buildLyric(context, lyricData.fontSize)],
            // );
          },
        ),
      ),
    );
  }

  Iterable<Widget> _buildLyric(BuildContext context, double fontSize) {
    final maxWidth = MediaQuery.of(context).size.width * .33; // oppure .5
    // print(fontSize);
    var lines = _body.split('\n');
    var result = new List<Widget>();

    var paragraphArray = [];
    var paragraphValue = "";
    for (var i = 0; i < lines.length; i++) {
      if (lines[i] == "") {
        // se la riga precedente è vuota
        if (i > 0 && lines[i - 1] == "") continue;
        paragraphArray.add(paragraphValue);
        paragraphValue = "";
        continue;
      }

      paragraphValue += lines[i] + "\n";
    }

    for (var i = 0; i < paragraphArray.length; i++) {
      if (i % 3 == 0 && i != 0) {
        result.add(_child);
      }

      result.add(
        Container(
          // color: Colors.red,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: RichText(
              text: TextSpan(
                  children: [..._fontWeight(paragraphArray[i], fontSize)]),
            ),
          ),
        ),
      );
    }

    if (lines.length < 3) {
      result.add(_child);
    }

    return result;
  }

  List<TextSpan> _fontWeight(String lineText, double fontSize) {
    var j = 0;
    var fontweightSplitted = lineText.split('{b}');

    var result = List<TextSpan>();

    fontweightSplitted.forEach((value) {
      var marckupClosedExp = new RegExp('(\{\/b\})');

      if (fontweightSplitted.length - 1 == j) {
        value = '$value\n';
      }

      if (marckupClosedExp.hasMatch(value)) {
        var textBold = value.replaceAll(marckupClosedExp, '');
        result.add(TextSpan(
            text: textBold,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                color: Colors.black)));
      } else {
        result.add(TextSpan(
            text: value,
            style: TextStyle(fontSize: fontSize, color: Colors.black)));
      }
    });

    return result;
  }

  Future<void> _settingModalBottomSheet(context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                color: Theme.of(context).dialogBackgroundColor,
                width: constraints.maxWidth,
                height: 200,
                child: Consumer<SongLyric>(
                  builder: (context, data, child) {
                    return Wrap(
                      // mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                            leading: Icon(Icons.text_fields, size: 30),
                            title: Text('Grande'),
                            trailing: data.fontSize >= 30
                                ? Icon(FontAwesomeIcons.check, size: 16)
                                : Text('imposta'),
                            onTap: () {
                              data.fontSize = 30;
                              Navigator.of(context).pop();
                            }),
                        ListTile(
                            leading: Icon(Icons.text_fields, size: 22.5),
                            title: Text('Normale'),
                            trailing: data.fontSize < 30 && data.fontSize > 15
                                ? Icon(FontAwesomeIcons.check, size: 16)
                                : Text('imposta'),
                            onTap: () {
                              data.fontSize = 22.5;
                              Navigator.of(context).pop();
                            }),
                        ListTile(
                            leading: Icon(Icons.text_fields, size: 15),
                            title: Text('Piccolo'),
                            trailing: data.fontSize <= 15
                                ? Icon(FontAwesomeIcons.check, size: 16)
                                : Text('imposta'),
                            onTap: () {
                              data.fontSize = 15;
                              Navigator.of(context).pop();
                            }),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
