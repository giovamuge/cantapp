import 'package:flutter/widgets.dart';

class LyricWidget extends StatelessWidget {
  const LyricWidget({
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
