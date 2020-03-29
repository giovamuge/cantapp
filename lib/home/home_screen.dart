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

class _HomeScreenState extends State<HomeScreen> {
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
    // if (_songsData.items.length == 0) {
    //   return Center(
    //     child: Text("Non esistono canzoni"),
    //   );
    // }

    return Scaffold(
      // backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // TitleWidget(
                //   "Cantapp",
                //   padding: const EdgeInsets.only(
                //       top: 30, left: 15, right: 15, bottom: 15),
                // ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return ClipPath(
                      clipper: BackgroundClipper(),
                      child: Container(
                        color: appTheme.primaryColor,
                        width: constraints.maxWidth,
                        height: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text("Cantapp",
                                      style:
                                          Theme.of(context).textTheme.display4),
                                  Text(
                                      "Ciao, \nquale canto liturgico stai cercando?"),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: RaisedButton(
                                onPressed: () => showSearch(
                                  context: context,
                                  delegate:
                                      SongSearchDelegate(songsData: _songsData),
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
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // ClipRRect(
                //   child: Container(
                //     padding: const EdgeInsets.only(bottom: 50),
                //     decoration:
                //         BoxDecoration(color: Theme.of(context).primaryColor),
                //     child: Column(
                //       children: <Widget>[
                //         Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 15),
                //           child: RaisedButton(
                //             onPressed: () => showSearch(
                //               context: context,
                //               delegate:
                //                   SongSearchDelegate(songsData: _songsData),
                //             ),
                //             elevation: 0,
                //             hoverElevation: 0,
                //             focusElevation: 0,
                //             highlightElevation: 0,
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(10)),
                //             child: Row(
                //               children: <Widget>[
                //                 Icon(
                //                   Icons.search,
                //                   size: 17.00,
                //                 ),
                //                 SizedBox(
                //                   width: 5,
                //                 ),
                //                 Text("Cerca")
                //               ],
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                //   borderRadius: BorderRadius.only(
                //       bottomLeft: Radius.circular(100),
                //       bottomRight: Radius.circular(100)),
                // ),

                SizedBox(height: 10),
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
      ),
    );
  }
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
