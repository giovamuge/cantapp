import 'dart:convert';

import 'package:cantapp/song/servizi/youtube_model.dart';
import 'package:http/http.dart' as http;

class YouTubeApi {
  // get video info of youtube
  // response youtube video model
  Future<YouTubeModel> fetchVideo(String url) async {
    final response =
        await http.get('https://www.youtube.com/oembed?url=$url&format=json');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return YouTubeModel.formMap(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load video');
    }
  }
}
