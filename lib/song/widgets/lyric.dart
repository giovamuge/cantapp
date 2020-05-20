import 'package:flutter/widgets.dart';

class LyricWidget extends StatelessWidget {
  final String _text;
  final double _fontSize;
  final Widget _child;

  const LyricWidget(
      {Key key, @required String text, @required double fontSize, Widget child})
      : _fontSize = fontSize,
        _text = text,
        _child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // return RichText(
    //   text: TextSpan(
    //     style: DefaultTextStyle.of(context).style,
    //     // children: _splitFontWight(_text),
    //   ),
    // );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _test(context),
    );
  }

  List<Widget> _test(context) {
    // regex da implementare e cambiare logica
    // var exp = new RegExp('(\{b\})+(.*?)+(\{\/b\})');
    var result = new List<Widget>();
    var richText = new List<TextSpan>();
    var admobAdded = false;
    var k = 0;

    // ottengo una lista di righe
    // nel quale sono presenti anche i valori
    // in grassetto
    final newlineSplited = _text.split('\n');
    for (var i = 0; i < newlineSplited.length; i++) {
      final newline = newlineSplited[i];
      // separo il testo normale da quello
      // in grassetto, ottenendo una lista
      final fontweightSplitted = newline.split('{b}');
      var j = 0;

      for (var y = 0; y < fontweightSplitted.length; y++) {
        var value = fontweightSplitted[y];

        // se raggiungo la fine della riga
        // inserisco '\n' un invio a capo
        if (fontweightSplitted.length - 1 == j) {
          if (value.isEmpty) k++;
          value = '$value\n';
        }

        // controllo se è un testo in grassetto o normale
        // nel caso fosse grassetto rimuovo il dato e cambio font
        final marckupClosedExp = new RegExp('(\{\/b\})');
        if (marckupClosedExp.hasMatch(value)) {
          final textBold = value.replaceAll(marckupClosedExp, '');
          richText.add(TextSpan(
            text: textBold,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: _fontSize),
          ));
        } else {
          richText.add(TextSpan(
            text: value,
            style: TextStyle(fontSize: _fontSize),
          ));
        }

        if (k > 1 && !admobAdded) {
          result.add(buildRichText(richText, context));
          result.add(buildChild());
          admobAdded = true;
          richText.clear();
        }

        j++;
      }
    }

    result.add(buildRichText(richText, context));
    if (!admobAdded) result.add(buildChild());
    return result;
  }

  Widget buildChild() {
    return Container(
        alignment: Alignment.center,
        child: _child,
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 30));
  }

  RichText buildRichText(richText, context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: richText,
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
