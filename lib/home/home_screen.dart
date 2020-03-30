import 'package:cantapp/common/theme.dart';
import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/home/widgets/song_search.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/song_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    implements AutomaticKeepAliveClientMixin<HomeScreen> {
  Songs _songsData;

  @override
  void initState() {
    super.initState();
  }

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    _songsData = Provider.of<Songs>(context);
    await _songsData.fetchSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: appTheme.primaryColor),
            child: Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Cantapp\n",
                        style: Theme.of(context).textTheme.display4),
                    TextSpan(
                        text: "Ciao, \nquale canto liturgico stai cercando?",
                        style: Theme.of(context).textTheme.subhead)
                  ]),
                ),
                RaisedButton(
                  onPressed: () => showSearch(
                    context: context,
                    delegate: SongSearchDelegate(songsData: _songsData),
                  ),
                  elevation: 0,
                  hoverElevation: 0,
                  focusElevation: 0,
                  highlightElevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.search,
                        size: 17.00,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Cerca")
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return SongWidget(song: _songsData.items[index], number: index);
            },
            itemCount: _songsData.items.length,
          ),
        ],
      )),
    );
  }

  @override
  void updateKeepAlive() {}

  @override
  bool get wantKeepAlive => true;
}

class TitleWidget extends StatelessWidget {
  final String _title;
  final EdgeInsetsGeometry _padding;

  TitleWidget(
    String title, {
    Key key,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 15),
  })  : _title = title,
        _padding = padding;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: _padding,
        alignment: Alignment.centerLeft,
        child: Text(_title, style: TextStyle(fontSize: 50)));
  }
}

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
        title: Text('${song.number}. ${song.title}'),
        // isThreeLine: true,
        // subtitle: Text("Prova"),
        dense: true,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            // fullscreenDialog: true, // sono sicuro?
            builder: (context) => SongScreen(song: song))),
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

// class CurvePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint();
//     paint.color = appTheme.primaryColor;
//     paint.style = PaintingStyle.fill; // Change this to fill

//     var path = Path();

//     path.moveTo(0, size.height * 0.25);
//     path.quadraticBezierTo(
//         size.width / 2, size.height / 2, size.width, size.height * 0.25);
//     path.lineTo(size.width, 0);
//     path.lineTo(0, 0);

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.moveTo(0, size.height * .75);
    path.quadraticBezierTo(
        size.width / 2, size.height / 2, size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    // canvas.drawPath(path, paint);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
