import 'package:cantapp/song/song_lyric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FontSizeSliderWidget extends StatefulWidget {
  final bool collasped;
  const FontSizeSliderWidget({this.collasped = false});

  @override
  _FontSizeSliderWidgetState createState() => _FontSizeSliderWidgetState();
}

class _FontSizeSliderWidgetState extends State<FontSizeSliderWidget>
    with TickerProviderStateMixin {
  GlobalKey _keyFoldChild;

  @override
  void initState() {
    _keyFoldChild = GlobalKey();
    // WidgetsBinding.instance..addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SongLyric>(
      builder: (context, lyric, child) {
        return AnimatedSize(
          duration: const Duration(milliseconds: 350),
          vsync: this,
          child: ClipRect(
            child: SizedOverflowBox(
              size: !widget.collasped
                  ? Size(MediaQuery.of(context).size.width, 0.00)
                  : Size(MediaQuery.of(context).size.width, 50),
              child: Container(
                key: _keyFoldChild,
                child: Slider(
                  min: 10,
                  max: 35,
                  value: lyric.fontSize,
                  onChanged: (value) => lyric.fontSize = value,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
