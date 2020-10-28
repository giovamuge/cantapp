import 'package:algolia/algolia.dart';
import 'package:cantapp/services/algolia_service.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/song_screen.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataSearch extends SearchDelegate {
  // Songs _songsData;
  // SongSearchDelegate();

  @override
  ThemeData appBarTheme(BuildContext context) {
    // return super.appBarTheme(context);
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: theme.backgroundColor,
      // primaryIconTheme: theme.primaryIconTheme,
      // primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme,
    );
  }

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
                      builder: (context) => SongScreen(id: items[index].id))));
            },
          );
        } else {
          return Center(child: Text("Nessun risultato trovato. 🤔"));
        }
      },
    );
  }
}

class SongSearchDelegate extends SearchDelegate<String> {
  final AlgoliaService _algoliaService = AlgoliaService.instance;

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for app bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the app bar
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: ConnectivityWrapper.instance.isConnected,
      builder: (context, isConnected) {
        if (isConnected.hasData && isConnected.data) {
          return FutureBuilder<List<SongLight>>(
            future: _algoliaService.performMovieQuery(text: query),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // ottengo song list
                final songs = snapshot.data;
                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (ctx, i) => ListTile(
                    leading: Text("numero"),
                    title: Text(songs[i].title),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          print('id:' + songs[i].id);
                          return SongScreen(id: songs[i].id);
                        },
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error.toString()}"),
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        } else {
          // List<Song> songListData = List<Song>();
          final database = Provider.of<FirestoreDatabase>(context,
              listen: false); // potrebbe essere true, da verificare

          print('i am searching:  -> $query');

          return StreamBuilder(
            stream: database.songsSearchStream(textSearch: query.toLowerCase()),
            builder:
                (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                final List<Song> items = snapshot.data;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(items[index].title),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    SongScreen(id: items[index].id))));
                  },
                );
              } else {
                return Center(child: Text("Nessun risultato trovato. 🤔"));
              }
            },
          );
        }
      },
    );
  }
}

///
/// Initiate static Algolia once in your project.
///
class Application {
  static final Algolia algolia = Algolia.init(
    applicationId: 'MYFNFA4QU7',
    apiKey: 'bcf8b392f6dacaa188445ccf24e2467d',
  );
}
