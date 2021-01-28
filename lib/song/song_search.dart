import 'package:algolia/algolia.dart';
import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/services/algolia_service.dart';
import 'package:cantapp/song/bloc/songs_bloc.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/song_screen.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SongSearchDelegate extends SearchDelegate<String> {
  final AlgoliaService _algoliaService = AlgoliaService.instance;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final themeData = Provider.of<ThemeChanger>(context, listen: false);
    final ThemeData theme = Theme.of(context);
    final result = themeData.getThemeName() == Constants.themeLight
        ? theme.copyWith(
            primaryColor: AppTheme.background,
            primaryColorBrightness: Brightness.light)
        : theme.copyWith(
            primaryColor: AppTheme.backgroundDark,
            primaryColorBrightness: Brightness.dark);

    return result;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the app bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
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
          return FutureBuilder<List<SongResult>>(
            future: _algoliaService.performMovieQuery(text: query),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // ottengo song list
                final songs = snapshot.data;
                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (ctx, i) {
                    return ListTile(
                      title: Text(songs[i].title),
                      subtitle: Text(songs[i].lyric, maxLines: 1),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            print('id:' + songs[i].objectID);
                            return SongScreen(id: songs[i].objectID);
                          },
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Errore di connessione."),
                );
              }

              final theme = Provider.of<ThemeChanger>(context, listen: false);
              final double sizeWidth = MediaQuery.of(context).size.width;
              final double titleWidth = sizeWidth * 0.55;
              final double subtitleWidth = sizeWidth * 0.75;

              return Shimmer.fromColors(
                // baseColor: Theme.of(context).primaryColorLight,
                // highlightColor: Theme.of(context).primaryColor,
                baseColor: theme.getThemeName() == Constants.themeLight
                    ? Colors.grey[100]
                    : Colors.grey[600],
                highlightColor: theme.getThemeName() == Constants.themeLight
                    ? Colors.grey[300]
                    : Colors.grey[900],
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: titleWidth,
                            height: 15.00,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.5),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: subtitleWidth,
                            height: 15.00,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.5),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: List.generate(15, (i) => i++).length,
                ),
              );
            },
          );
        } else {
          print('i am searching:  -> $query');

          return StreamBuilder(
            stream: BlocProvider.of<SongsBloc>(context)
                .songsSearchStream(query.toLowerCase()),
            builder: (BuildContext context,
                AsyncSnapshot<List<SongLight>> snapshot) {
              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                final List<SongLight> items = snapshot.data;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[index].title),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SongScreen(id: items[index].id),
                        ),
                      ),
                    );
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
