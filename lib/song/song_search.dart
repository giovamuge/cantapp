import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/services/full_text_search/full_text_search.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/song_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SongSearchDelegate extends SearchDelegate<String> {
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
    return FutureBuilder<List<SongResult>>(
      future: FullTextSearch.instance.search(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // ottengo song list
          final songs = snapshot.data;
          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (ctx, i) {
              return ListTile(
                title: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: highlightOccurrences(songs[i].title, query),
                  ),
                ),
                subtitle:
                    Text(songs[i].artist ?? "Artista sconosciuto", maxLines: 1),
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
  }

  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query == null ||
        query.isEmpty ||
        !source.toLowerCase().contains(query.toLowerCase())) {
      return [TextSpan(text: source)];
    }
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: TextStyle(fontWeight: FontWeight.bold),
      ));

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
        ));
      }

      lastMatchEnd = match.end;
    }

    return children;
  }
}
