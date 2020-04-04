import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/favorite/favorite_screen.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/song_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SongWidget extends StatelessWidget {
  final Song song;
  final int number;

  const SongWidget({Key key, @required this.song, @required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var favoritesData = Provider.of<Favorites>(context);
    return Consumer<Favorites>(
      builder: (ctx, favoritesData, child) => ListTile(
        leading: CircleAvatar(
          maxRadius: 17,
          backgroundColor: Colors.purple[100],
          child: Text(
            '${song.number}',
            style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.w800,
                fontSize: 10),
          ),
        ),
        title: Text('${song.title}'),
        // isThreeLine: true,
        // subtitle: Text("Prova"),
        dense: true,
        onTap: () => _navigateToSong(context, song),
        trailing: PopupMenuButton<OptionSong>(
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

  List<PopupMenuEntry<OptionSong>> _buildOptions(
      BuildContext context, Favorites data) {
    List<PopupMenuItem<OptionSong>> result = [];
    if (data.exist(song.id)) {
      result.add(const PopupMenuItem<OptionSong>(
        value: OptionSong.remove,
        child: Text('💔 elimina preferito'),
      ));
    } else {
      result.add(const PopupMenuItem<OptionSong>(
        value: OptionSong.add,
        child: Text('❤️ salva preferito'),
      ));
    }

    return [
      ...result,
      const PopupMenuItem<OptionSong>(
        value: OptionSong.view,
        child: Text('🎶 canta'),
      ),
    ];
  }

  _messageSnackbar(BuildContext context, OptionSong option) {
    String msg;
    if (option == OptionSong.add) {
      msg = '${song.title} ❤️ aggiunto hai preferiti';
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
