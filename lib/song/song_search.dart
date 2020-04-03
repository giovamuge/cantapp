import 'package:cantapp/song/song_model.dart';
import 'package:flutter/material.dart';

class SongSearchDelegate extends SearchDelegate {
  Songs _songsData;
  SongSearchDelegate({@required songsData}) : _songsData = songsData;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => searchSongs();

  @override
  Widget buildSuggestions(BuildContext context) => searchSongs();

  Widget searchSongs() {
    List<Song> _songs = _songsData.items;

    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    // var songSearchList = new List<Song>();
    // songSearchList.addAll(_songs);

    List<Song> songListData = List<Song>();
    _songs.forEach((item) {
      var title = item.title.toLowerCase();
      var querylow = query.toLowerCase();

      if (title.contains(querylow)) {
        songListData.add(item);
      }
    });

    if (songListData.length == 0) {
      return Column(
        children: <Widget>[
          Text(
            "Nessun risultato trovato.",
          ),
        ],
      );
    } else {
      return ListView.builder(
        itemCount: songListData.length,
        itemBuilder: (context, index) {
          var result = songListData[index];
          return ListTile(
            title: Text(result.title),
          );
        },
      );
    }
  }
}
