import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/song_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SongSearchDelegate extends SearchDelegate {
  // Songs _songsData;
  // SongSearchDelegate();

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
  Widget buildResults(BuildContext context) => searchSongs(context);

  @override
  Widget buildSuggestions(BuildContext context) => searchSongs(
      context); // da sostituire con Container se non vuoi lasciare in pending l'ultima ricerca

  Widget searchSongs(BuildContext context) {
    if (query.length < 2) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Inserisci più di due ✌️ lettere \nper la ricerca. ",
              textAlign: TextAlign.center,
            ),
          )
        ],
      );
    }

    // List<Song> songListData = List<Song>();
    final database = Provider.of<FirestoreDatabase>(context,
        listen: false); // potrebbe essere true, da verificare

    print('i am searching:  -> $query');

    return StreamBuilder(
        stream: database.songsSearchStream(textSearch: query.toLowerCase()),
        builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            final List<Song> items = snapshot.data;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(items[index].title),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SongScreen(song: items[index]))));
              },
            );
          } else {
            return Center(child: Text("Nessun risultato trovato. 🤔"));
          }
        });
  }
}
