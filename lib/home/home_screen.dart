import 'package:cantapp/favorite/heart.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Songs _songsData;
  List<Song> _songs = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    _songsData = Provider.of<Songs>(context);
    await _songsData.fetchSongs();
    // var songs = _songsData.items;
    // if (songs != _songs) {
    //   _songs = songs;
    //   print(_songs);
    // }
  }

  @override
  Widget build(BuildContext context) {
    // if (_songsData.items.length == 0) {
    //   return Center(
    //     child: Text("Non esistono canzoni"),
    //   );
    // }

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.centerLeft,
                  child: Text("Cantapp", style: TextStyle(fontSize: 50))),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    // fillColor: Color(0xFFDBEDFF),
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Cerca',
                    // hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 50),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return SongWidget(
                      song: _songsData.items[index], number: index);
                },
                itemCount: _songsData.items.length,
              ),
            ],
          );
        },
      ),
    );
  }
}

class SongWidget extends StatelessWidget {
  final Song song;
  final int number;

  const SongWidget({Key key, @required this.song, @required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var heartsData = Provider.of<Hearts>(context);
    return ListTile(
      title: Text('${song.number}. ${song.title}'),
      // isThreeLine: true,
      // subtitle: Text("Prova"),
      dense: true,
      trailing: PopupMenuButton<OptionSong>(
        onSelected: (OptionSong result) {
          if (result == OptionSong.add) {
            heartsData.addHeart(song.id);
          }

          if (result == OptionSong.remove) {
            heartsData.removeHeart(song.id);
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
    );
  }
}

enum OptionSong { add, remove }
