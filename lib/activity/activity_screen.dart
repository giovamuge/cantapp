import 'dart:async';

import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/song_item.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  final int index;
  final String title;
  final MaterialColor color;

  ActivityScreen(
      {@required this.index, @required this.color, @required this.title});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool _visible;

  @override
  void initState() {
    _visible = false;

    Timer(const Duration(milliseconds: 500),
        () => setState(() => _visible = true));

    super.initState();
  }

  @override
  void dispose() {
    _visible = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Per correggere l'animazione rimuovere scaffold
    // Trovare soluzione per iconData
    // var _songsData = Provider.of<Songs>(context, listen: false);
    final database = Provider.of<FirestoreDatabase>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
            tag: "background-${widget.index}",
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.color[200], widget.color[400]],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
          StreamBuilder<List<Song>>(
            stream: database.songsStream(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                // setState(() => _visible = true);
                final List<Song> items = snapshot.data;
                return AnimatedOpacity(
                  curve: Curves.bounceIn,
                  opacity: _visible ? 1.00 : 0.00,
                  duration: Duration(milliseconds: 350),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 10),
                          child: IconButton(
                              icon: Icon(Icons.close),
                              color: widget.color[800],
                              onPressed: () {
                                setState(() => _visible = false);
                                Navigator.pop(context);
                              }),
                        ),
                        // Align(
                        //   alignment: Alignment.topRight,
                        //   child: Hero(
                        //       tag: "image-$index",
                        //       child: Image.asset(widget.character.imagePath,
                        //           height: screenHeight * 0.45)),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8),
                          child: Text(
                            widget.title ?? "",
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: widget.color[800]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return SongWidget(
                                song: items[index],
                                number: index,
                                avatarColor: widget.color,
                                textColor: widget.color,
                              );
                            },
                            itemCount: items.length,
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(20, 0, 8, 32),
                        //   child: Consumer<Songs>(
                        //     builder: (ctx, _songsData, child) {
                        //       return ListView.builder(
                        //         shrinkWrap: true,
                        //         physics: const NeverScrollableScrollPhysics(),
                        //         itemBuilder: (BuildContext context, int index) {
                        //           return SongWidget(
                        //               song: _songsData.items[index],
                        //               number: index);
                        //         },
                        //         itemCount: _songsData.items.length,
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("C'è un errore 😖 riprova tra qualche istante."),
                );
              }

              return Column(
                children: <Widget>[
                  Text("Non ci sono dati 🤷‍♂️"),
                  FlatButton(
                      child: Text("Chiudi"),
                      onPressed: () => Navigator.pop(context))
                ],
              );
            },
          )
        ],
      ),
    );
  }
}

// esempio con statless
//
// class ActivityScreen extends StatelessWidget {
//   final int index;
//   final String title;
//   final MaterialColor color;

//   ActivityScreen(
//       {@required this.index, @required this.color, @required this.title});

//   @override
//   Widget build(BuildContext context) {
//     var _songsData = Provider.of<Songs>(context, listen: false);
//     Future(() async => await _songsData.fetchSongs());

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           Hero(
//             tag: "background-$index",
//             child: DecoratedBox(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [color[200], color[400]],
//                   begin: Alignment.topRight,
//                   end: Alignment.bottomLeft,
//                 ),
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0, left: 10),
//                   child: IconButton(
//                       icon: Icon(Icons.close),
//                       color: color[800],
//                       onPressed: () {
//                         Timer(const Duration(milliseconds: 500),
//                             () => Navigator.pop(context));
//                       }),
//                 ),
//                 // Align(
//                 //   alignment: Alignment.topRight,
//                 //   child: Hero(
//                 //       tag: "image-$index",
//                 //       child: Image.asset(widget.character.imagePath,
//                 //           height: screenHeight * 0.45)),
//                 // ),
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
//                   child: Hero(
//                     tag: "name-$index",
//                     child: Material(
//                       color: Colors.transparent,
//                       child: Container(
//                         child: Text(
//                           title ?? "",
//                           style: TextStyle(
//                               fontSize: 35,
//                               fontWeight: FontWeight.bold,
//                               color: color[800]),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 AnimatedOpacity(
//                   // opacity: _visible ? 1.00 : 0.00,
//                   opacity: 1.00,
//                   duration: Duration(milliseconds: 350),
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 0, 8, 32),
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemBuilder: (BuildContext context, int index) {
//                         return SongWidget(
//                             song: _songsData.items[index], number: index);
//                       },
//                       itemCount: _songsData.items.length,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
