import 'package:url_launcher/url_launcher.dart';

class Utils {
  static launchURL() async {
    const url = 'https://www.youtube.com/watch?v=oCuucODgzhM';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
