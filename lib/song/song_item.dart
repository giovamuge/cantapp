import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/song_screen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
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
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              // fullscreenDialog: true, // sono sicuro?
              builder: (context) => SongScreen(song: song)),
        ),
        trailing: PopupMenuButton<OptionSong>(
          onSelected: (OptionSong result) {
            if (result == OptionSong.add) {
              favoritesData.addFavorite(song.id);
            }

            if (result == OptionSong.remove) {
              favoritesData.removeFavorite(song.id);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<OptionSong>>[
            const PopupMenuItem<OptionSong>(
              value: OptionSong.add,
              child: Text('Aggiungi preferito'),
            ),
            const PopupMenuItem<OptionSong>(
              value: OptionSong.remove,
              child: Text('Rimuovi preferito'),
            ),
          ],
        ),
      ),
    );
  }
}

enum OptionSong { add, remove }
