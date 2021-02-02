import 'package:flutter/material.dart';

class LyricUtil {
  Iterable<Widget> buildLyric(
      BuildContext context, String text, double fontSize, Widget child) {
    // final maxWidth = MediaQuery.of(context).size.width * .33; // oppure .5
    // print(fontSize);
    var lines = text.split('\n');
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
        result.add(child);
      }

      result.add(
        Container(
          child: RichText(
            text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [...fontWeight(paragraphArray[i], fontSize)]),
          ),
        ),
      );
    }

    if (paragraphArray.length < 3) {
      result.add(child);
    }

    return result;
  }

  List<TextSpan> fontWeight(String lineText, double fontSize) {
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)));
      } else {
        result.add(TextSpan(text: value, style: TextStyle(fontSize: fontSize)));
      }
    });

    return result;
  }
}
