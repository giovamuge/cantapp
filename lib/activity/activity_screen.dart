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

class _ActivityScreenState extends State<ActivityScreen>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    Timer(const Duration(milliseconds: 500),
        () => _animationController.forward());

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    _animation = null;
    _animationController.dispose();
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
          StreamBuilder<List<SongLight>>(
            stream: database.activitySongsStream(widget.index),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && snapshot.data.length > 0) {
                final List<SongLight> items = snapshot.data;
                return AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Opacity(opacity: _animation.value, child: child);
                  },
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
                                _animationController
                                    .reverse()
                                    .then((value) => Navigator.pop(context));
                              }),
                        ),
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
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Opacity(opacity: _animation.value, child: child);
                  },
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("C'è un errore 😖 riprova tra qualche istante."),
                        FlatButton(
                            child: Text(
                              "Chiudi",
                              style: TextStyle(
                                color: widget.color[800],
                              ),
                            ),
                            textColor: widget.color[800],
                            onPressed: () {
                              _animationController
                                  .reverse()
                                  .then((value) => Navigator.pop(context));
                            }),
                      ],
                    ),
                  ),
                );
              }

              return AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Opacity(opacity: _animation.value, child: child);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Non ci sono dati 🤷‍♂️",
                      style: TextStyle(
                        color: widget.color[800],
                      ),
                    ),
                    FlatButton(
                        child: Text("Chiudi"),
                        textColor: widget.color[800],
                        onPressed: () {
                          _animationController
                              .reverse()
                              .then((value) => Navigator.pop(context));
                        })
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
