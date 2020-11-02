import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/extensions/string.dart';
import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/favorite/favorite_screen.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/song_screen.dart';
import 'package:cantapp/song/widgets/badget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SongWidget extends StatelessWidget {
  final SongLight song;
  final int number;
  final MaterialColor _avatarColor;
  final MaterialColor _textColor;

  // static const Color _defaultPrimaryColor = Theme.of(context).primaryColor;

  static const MaterialColor _defaultTextColor = MaterialColor(
    0xFF000000,
    <int, Color>{
      50: Color(0xFF000000),
      100: Color(0xFF000000),
      200: Color(0xFF000000),
      300: Color(0xFF000000),
      400: Color(0xFF000000),
      500: Color(0xFF000000),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );

  const SongWidget(
      {Key key,
      @required this.song,
      @required this.number,
      avatarColor,
      textColor})
      : _avatarColor = avatarColor ?? Colors.purple,
        _textColor = textColor ?? _defaultTextColor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // var favoritesData = Provider.of<Favorites>(context);
    return Consumer<Favorites>(
      builder: (ctx, favoritesData, child) => ListTile(
        leading: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Color(0xFF48639C), //_avatarColor[100]
          ),
          child: Center(
            child: Text(
              '${number + 1}',
              style: TextStyle(
                  color: Color(0xFFFFFFFF), //_avatarColor[900],
                  fontWeight: FontWeight.w800,
                  fontSize: 11),
            ),
          ),
        ),
        title: Text(
          '${song.title}',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              // color: _textColor[900],
              color: Theme.of(context).primaryColor,
              fontSize: 15),
        ),
        // subtitle: Text('Artista sconosciuto',
        //     style: TextStyle(color: _textColor[900], fontSize: 11)),
        subtitle: Container(
          child: Row(children: _buildSubtitle()),
        ),
        // isThreeLine: true,
        // subtitle: Text("Prova"),
        dense: true,
        onTap: () => _navigateToSong(context, song),
        // trailing: PopupMenuButton<OptionSong>(
        //   // color: _textColor[900],
        //   onSelected: (OptionSong result) async {
        //     if (result == OptionSong.add) {
        //       await favoritesData.addFavorite(song.id);
        //       _messageSnackbar(context, OptionSong.add);
        //     }

        //     if (result == OptionSong.remove) {
        //       await favoritesData.removeFavorite(song.id);
        //       _messageSnackbar(context, OptionSong.remove);
        //     }

        //     if (result == OptionSong.view) {
        //       _navigateToSong(context, song);
        //     }
        //   },
        //   itemBuilder: (ctx) => _buildOptions(ctx, favoritesData),
        // ),
        trailing: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _settingModalBottomSheet(context, song.id)),
      ),
    );
  }

  List<Widget> _buildSubtitle() {
    final result = new List<Widget>();

    // if (!song.chord.isNullOrEmpty()) {
    //   result.add(
    //     Padding(
    //       padding: const EdgeInsets.only(right: 5),
    //       child: BadgetWidget(
    //         title: 'accordi',
    //         color: Colors.pink,
    //       ),
    //     ),
    //   );
    // }

    if (song.links.any((l) => l.type == 'youtube')) {
      result.add(
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: BadgetWidget(
            title: 'video',
            color: Colors.lightGreen,
          ),
        ),
      );
    }

    if (song.links.any((l) => l.type == 'audio')) {
      result.add(
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: BadgetWidget(
            title: 'audio',
            color: Colors.lightBlue,
          ),
        ),
      );
    }

    result.add(
      Flexible(
        child: Text(
            !song.artist.isNullOrEmpty() ? song.artist : 'Artista conosciuto',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11)),
      ),
    );

    // controlli per links e audio
    // aggiungere alla lista se esistono

    return result;
  }

  List<PopupMenuEntry<OptionSong>> _buildOptions(
      BuildContext context, Favorites data) {
    PopupMenuItem<OptionSong> result;
    // if (data.exist(song.id)) {
    //   result = const PopupMenuItem<OptionSong>(
    //     value: OptionSong.remove,
    //     child: Text('💔 elimina preferito'),
    //   );
    // } else {
    //   result = const PopupMenuItem<OptionSong>(
    //     value: OptionSong.add,
    //     child: Text('❤️ salva preferito'),
    //   );
    // }

    return [
      result,
      const PopupMenuItem<OptionSong>(
        value: OptionSong.view,
        child: Text('🎶 canta'),
      ),
    ];
  }

  Future<void> _settingModalBottomSheet(contextScaffold, songId) async {
    final firestore = GetIt.instance<FirestoreDatabase>();
    return await showModalBottomSheet(
        context: contextScaffold,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: Theme.of(context).dialogBackgroundColor,
                  width: constraints.maxWidth,
                  height: 200,
                  child: Consumer<Favorites>(
                    builder: (context, favoritesData, child) {
                      return StreamBuilder<bool>(
                        stream: firestore.existSongInFavoriteStream(songId),
                        builder: (context, data) {
                          if (data.connectionState != ConnectionState.waiting &&
                              data.hasData) {
                            final exist = data.data;
                            return Wrap(
                              children: <Widget>[
                                if (exist)
                                  ListTile(
                                    leading: Icon(Icons.favorite),
                                    title: Text("Rimuovi preferito"),
                                    onTap: () async {
                                      await favoritesData
                                          .removeFavorite(song.id);
                                      Navigator.of(context).pop();
                                      await _messageSnackbar(
                                          contextScaffold, OptionSong.remove);
                                    },
                                  ),
                                if (!exist)
                                  ListTile(
                                      leading: Icon(Icons.favorite_border),
                                      title: Text("Aggiungi preferito"),
                                      onTap: () async {
                                        await favoritesData
                                            .addFavorite(song.id);
                                        Navigator.of(context).pop();
                                        await _messageSnackbar(
                                            contextScaffold, OptionSong.add);
                                      }),
                                ListTile(
                                    leading: Icon(Icons.book),
                                    title: Text("Visualizza canto"),
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FavoriteScreen()))),
                                ListTile(
                                    leading: Icon(Icons.cancel),
                                    title: Text("Annulla"),
                                    onTap: () => Navigator.of(context).pop())
                              ],
                            );
                          } else {
                            final sizeWidth = MediaQuery.of(context).size.width;
                            var theme = Provider.of<ThemeChanger>(context,
                                listen: false);

                            return Shimmer.fromColors(
                              // baseColor: Theme.of(context).primaryColorLight,
                              // highlightColor: Theme.of(context).primaryColor,
                              baseColor:
                                  theme.getThemeName() == Constants.themeLight
                                      ? Colors.grey[100]
                                      : Colors.grey[600],
                              highlightColor:
                                  theme.getThemeName() == Constants.themeLight
                                      ? Colors.grey[300]
                                      : Colors.grey[900],
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    leading: Container(
                                      width: 35.00,
                                      height: 35.00,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Container(
                                      width: sizeWidth - 35.00,
                                      height: 30.00,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                                itemCount: List.generate(3, (i) => i++).length,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        });
  }

  _messageSnackbar(BuildContext context, OptionSong option) {
    String msg;
    if (option == OptionSong.add) {
      msg = '${song.title} ❤️ aggiunto ai preferiti';
    } else {
      msg = '${song.title} 💔 rimosso dai preferiti';
    }
    SnackBar snackBar = SnackBar(
      backgroundColor: Colors.purple[100],
      elevation: 5,
      behavior: SnackBarBehavior.floating,
      content: Text(msg),
      action: option == OptionSong.remove
          ? null
          : SnackBarAction(
              label: 'visualizza',
              textColor: Colors.purple[800],
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FavoriteScreen()),
              ),
            ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  _navigateToSong(context, song) => Navigator.of(context).push(
        MaterialPageRoute(
            // fullscreenDialog: true, // sono sicuro?
            builder: (context) => SongScreen(id: song.id)),
      );
}

enum OptionSong { add, remove, view }
