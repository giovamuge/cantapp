import 'package:cantapp/extensions/string.dart';
import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/favorite/favorite_screen.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/song_screen.dart';
import 'package:cantapp/song/widgets/badget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SongWidget extends StatelessWidget {
  final Song song;
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
        leading: CircleAvatar(
          maxRadius: 20,
          backgroundColor: _avatarColor[100],
          child: Text(
            '$number',
            style: TextStyle(
                color: _avatarColor[900],
                fontWeight: FontWeight.w800,
                fontSize: 11),
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
          child: Row(
            children: _buildSubtitle(),
          ),
        ),
        // isThreeLine: true,
        // subtitle: Text("Prova"),
        dense: true,
        onTap: () => _navigateToSong(context, song),
        trailing: PopupMenuButton<OptionSong>(
          // color: _textColor[900],
          onSelected: (OptionSong result) {
            if (result == OptionSong.add) {
              favoritesData.addFavorite(song.id);
              _messageSnackbar(context, OptionSong.add);
            }

            if (result == OptionSong.remove) {
              favoritesData.removeFavorite(song.id);
              _messageSnackbar(context, OptionSong.remove);
            }

            if (result == OptionSong.view) {
              _navigateToSong(context, song);
            }
          },
          itemBuilder: (ctx) => _buildOptions(ctx, favoritesData),
        ),
      ),
    );
  }

  List<Widget> _buildSubtitle() {
    final result = new List<Widget>();

    if (!song.chord.isNullOrEmpty()) {
      result.add(
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: BadgetWidget(
            title: 'accordi',
            color: Colors.pink,
          ),
        ),
      );
    }

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

    // if(song.links.any((l) => l.))

    result.add(Text(
        !song.artist.isNullOrEmpty() ? song.artist : 'Artista conosciuto',
        style: TextStyle(fontSize: 11)));

    // controlli per links e audio
    // aggiungere alla lista se esistono

    return result;
  }

  List<PopupMenuEntry<OptionSong>> _buildOptions(
      BuildContext context, Favorites data) {
    PopupMenuItem<OptionSong> result;
    if (data.exist(song.id)) {
      result = const PopupMenuItem<OptionSong>(
        value: OptionSong.remove,
        child: Text('💔 elimina preferito'),
      );
    } else {
      result = const PopupMenuItem<OptionSong>(
        value: OptionSong.add,
        child: Text('❤️ salva preferito'),
      );
    }

    return [
      result,
      const PopupMenuItem<OptionSong>(
        value: OptionSong.view,
        child: Text('🎶 canta'),
      ),
    ];
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
            builder: (context) => SongScreen(song: song)),
      );
}

enum OptionSong { add, remove, view }
