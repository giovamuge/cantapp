import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LyricWidget extends StatelessWidget {
  final String _text;
  final double _fontSize;
  final Widget _child;

  const LyricWidget({
    Key key,
    @required String text,
    @required double fontSize,
    Widget child,
  })  : _fontSize = fontSize,
        _text = text,
        _child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // RichText(
        //   text: TextSpan(
        //     style: DefaultTextStyle.of(context).style,
        //     children: _buildLyric(context, _text),
        //   ),
        // ),
        ..._buildLyric(context),
        // SizedBox(height: 30),
        // _child,
      ],
    );
  }

  RichText buildRichText(richText, context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: richText,
      ),
    );
  }

  Iterable<Widget> _buildLyric(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * .33; // oppure .5
    // print(fontSize);
    var lines = _text.split('\n');
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
      if ((i + 1) % 3 == 0 && i != 0) {
        result.add(_child);
      }

      result.add(
        Container(
          // color: Colors.red,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: RichText(
              text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [..._fontWeight(paragraphArray[i])]),
            ),
          ),
        ),
      );
    }

    if (paragraphArray.length < 3) {
      result.add(_child);
    }

    return result;
  }

  List<TextSpan> _fontWeight(String lineText) {
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
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: _fontSize)));
      } else {
        result
            .add(TextSpan(text: value, style: TextStyle(fontSize: _fontSize)));
      }
    });

    return result;
  }

  // List<TextSpan> _splitFontWight(String text) {
  //   // regex da implementare e cambiare logica
  //   // var exp = new RegExp('(\{b\})+(.*?)+(\{\/b\})');
  //   var result = List<TextSpan>();

  //   var newlineSplited = text.split('\n');
  //   newlineSplited.forEach((newline) {
  //     var j = 0;
  //     var fontweightSplitted = newline.split('{b}');

  //     fontweightSplitted.forEach((value) {
  //       var marckupClosedExp = new RegExp('(\{\/b\})');

  //       if (fontweightSplitted.length - 1 == j) {
  //         value = '$value\n';
  //       }

  //       if (marckupClosedExp.hasMatch(value)) {
  //         var textBold = value.replaceAll(marckupClosedExp, '');
  //         result.add(TextSpan(
  //             text: textBold,
  //             style:
  //                 TextStyle(fontWeight: FontWeight.bold, fontSize: _fontSize)));
  //       } else {
  //         result.add(
  //             TextSpan(text: value, style: TextStyle(fontSize: _fontSize)));
  //       }

  //       j++;
  //     });
  //   });
  //   return result;
  // }
}
