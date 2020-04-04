import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/song/song_lyric.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SongScreen extends StatefulWidget {
  final Song song;

  SongScreen({@required this.song});

  @override
  _SongScreenState createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> with TickerProviderStateMixin {
  // double _fontSize;
  GlobalKey _keyFoldChild;
  bool collapsed = false;
  double _childWidth;
  double _childHeight;
  AnimationController _controller;
  Animation<double> _sizeAnimation;
  bool _isFirst = true;
  bool _isPreferite = false;
  Favorites _favorites;
  SongLyric _lyricData;

  EdgeInsets safeAreaChildScroll = const EdgeInsets.symmetric(horizontal: 15);

  @override
  void initState() {
    super.initState();

    // _fontSize = 15.00;

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _keyFoldChild = GlobalKey();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    _lyricData = Provider.of<SongLyric>(context);
    _favorites = Provider.of<Favorites>(context);
    await _favorites.fetchFavorites();
  }

  void _afterLayout(_) {
    final RenderBox renderBox = _keyFoldChild.currentContext.findRenderObject();
    _childHeight = renderBox.size.height;
    _childWidth = renderBox.size.width;
    _sizeAnimation =
        Tween<double>(begin: 0.0, end: _childHeight).animate(_controller);

    var hasFavorite = _favorites.exist(widget.song.id);
    _isPreferite = hasFavorite;
  }

  @override
  Widget build(BuildContext context) {
    // return SafeArea(
    //   child:
    return Scaffold(
      body: SafeArea(
        // height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    BackButton(),
                    // IconButton(
                    //   icon: Icon(FontAwesomeIcons.chevronDown),
                    //   onPressed: () => Navigator.of(context).pop(),
                    // ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(_isPreferite
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart),
                          onPressed: () => _onPressedFavorite(),
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.font),
                          onPressed: () => _openCloseFontSize(),
                        ),
                      ],
                    ),
                  ],
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return ClipRect(
                      child: SizedOverflowBox(
                        size: _isFirst || _sizeAnimation == null
                            ? Size(MediaQuery.of(context).size.width, 0.00)
                            : Size(_childWidth, _sizeAnimation.value),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    key: _keyFoldChild,
                    child: Slider(
                      min: 10,
                      max: 35,
                      value: _lyricData.fontSize,
                      onChanged: (value) => _lyricData.fontSize = value,
                      // onChangeEnd: (value) => _lyricData.save(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: safeAreaChildScroll,
                  child: Text(
                    widget.song.title,
                    style: TextStyle(
                        fontSize: 25,
                        // fontSize: _fontSize + (_fontSize * .66),
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: safeAreaChildScroll,
                  child: Lyric(
                      text: widget.song.lyric, fontSize: _lyricData.fontSize),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: safeAreaChildScroll,
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.yellow,
                    type: MaterialType.card,
                    // padding: const EdgeInsets.all(10),
                    // decoration: BoxDecoration(
                    //     color: Colors.blue,
                    //     borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(FontAwesomeIcons.youtube),
                            color: Colors.white,
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.headphones),
                            color: Colors.white,
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.guitar),
                            color: Colors.white,
                            onPressed: () {},
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // ),
    );
  }

  _openCloseFontSize() {
    setState(() => collapsed = !collapsed);
    setState(() => _isFirst = false);

    if (collapsed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  _onPressedFavorite() {
    var uid = widget.song.id;
    if (_isPreferite) {
      _favorites.removeFavorite(uid);
    } else {
      _favorites.addFavorite(uid);
    }

    setState(() => _isPreferite = !_isPreferite);
  }
}

class Lyric extends StatelessWidget {
  const Lyric({
    Key key,
    @required String text,
    @required double fontSize,
  })  : _fontSize = fontSize,
        _text = text,
        super(key: key);

  final String _text;
  final double _fontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: _splitFontWight(_text),
      ),
    );
  }

  List<TextSpan> _splitFontWight(String text) {
    // regex da implementare e cambiare logica
    // var exp = new RegExp('(\{b\})+(.*?)+(\{\/b\})');
    var result = List<TextSpan>();

    var newlineSplited = text.split('\n');
    newlineSplited.forEach((newline) {
      var j = 0;
      var fontweightSplitted = newline.split('{b}');

      fontweightSplitted.forEach((value) {
        var marckupClosedExp = new RegExp('(\{\/b\})');

        if (fontweightSplitted.length - 1 == j) {
          value = '$value\n';
        }

        if (marckupClosedExp.hasMatch(value)) {
          var textBold = value.replaceAll(marckupClosedExp, '');
          result.add(TextSpan(
              text: textBold,
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: _fontSize)));
        } else {
          result.add(
              TextSpan(text: value, style: TextStyle(fontSize: _fontSize)));
        }

        j++;
      });
    });
    return result;
  }
}
