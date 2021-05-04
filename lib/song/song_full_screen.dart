import 'package:cantapp/song/song_lyric.dart';
import 'package:cantapp/song/utils/lyric_util.dart';
import 'package:cantapp/song/widgets/header_lyric.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'utils/song_util.dart';

class SongFullScreen extends StatefulWidget {
  final String _title;
  final String _number;
  final String _artist;
  final String _body;
  final List<String> _categories;
  final Widget _child;

  const SongFullScreen({
    required String body,
    required String title,
    required String number,
    Widget child,
    String artist,
    List<String> categories,
  })  : _body = body,
        _title = title,
        _number = number,
        _categories = categories,
        _artist = artist,
        _child = child;

  @override
  _SongFullScreenState createState() => _SongFullScreenState();
}

class _SongFullScreenState extends State<SongFullScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

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
            onPressed: () async =>
                await SongUtil().settingModalBottomSheet(context),
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
                // Text(
                //   _title,
                //   style: TextStyle(
                //     fontSize: lyricData.fontSize * 1.25,
                //     fontWeight: FontWeight.w800,
                //   ),
                // ),
                HeaderLyric(
                  title: widget._title,
                  number: widget._number,
                  categories: widget._categories,
                  artist: widget._artist,
                ),
                SizedBox(height: 20),
                ...LyricUtil().buildLyric(
                    context, widget._body, lyricData.fontSize, widget._child)
                // ..._buildLyric(context, lyricData.fontSize),
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
}
