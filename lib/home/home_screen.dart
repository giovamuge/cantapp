import 'package:cantapp/category/category_model.dart';
import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/bloc/song_bloc.dart';
import 'package:cantapp/song/song_search.dart';
import 'package:cantapp/song/song_item.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin
    implements AutomaticKeepAliveClientMixin<HomeScreen> {
  // Songs _songsData;
  bool _visible;
  ScrollController _controller;
  Animation _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _visible = false;
    _controller = ScrollController();
    _controller.addListener(_onScrolling);
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // _songsData = Provider.of<Songs>(context);
    // await _songsData.fetchSongs();
  }

  void _onScrolling() {
    // valore di offset costante
    const offset = 125;
    // Mostra il bottone search quando raggiungo
    // 120 di altezza, dove si trovara il bottone
    // grande search.
    if (_controller.offset <= offset && _visible) {
      _visible = false;
      _animationController.reverse();
    }

    // Nascondi in caso contrario
    // Controllo su _visible per non ripete il set continuamente
    if (_controller.offset > offset && !_visible) {
      _visible = true;
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: _animationController,
          builder: (ctx, child) {
            return Opacity(opacity: _animation.value, child: child);
          },
          child: Text("Cantapp"),
        ),
        actions: <Widget>[
          AnimatedBuilder(
            animation: _animationController,
            builder: (ctx, child) {
              return Opacity(opacity: _animation.value, child: child);
            },
            child: Center(
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => showSearch(
                  context: context,
                  delegate: SongSearchDelegate(),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: ListView(
        controller: _controller,
        // padding: EdgeInsets.symmetric(horizontal: 20),
        addAutomaticKeepAlives: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Quale canto stai\ncercando?",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RaisedButton(
              onPressed: () => showSearch(
                context: context,
                delegate: SongSearchDelegate(),
              ),
              elevation: .5,
              hoverElevation: .5,
              focusElevation: .5,
              highlightElevation: .5,
              color: Theme.of(context).dialogBackgroundColor,
              padding: const EdgeInsets.all(12),
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
          // SizedBox(height: 15),
          // ListActivityCardsWidget(),
          // SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20),
          //   child: Text(
          //     "Scegli una categoria",
          //     style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
          //   ),
          // ),
          SizedBox(height: 20),
          Container(
            height: 30.00,
            // padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: 20),
                ...Categories().items.map(
                      (e) => Consumer<Songs>(
                        builder: (context, songs, child) {
                          return Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.5),
                            child: RaisedButton(
                              color: songs.selected == e
                                  ? lightAccent
                                  : Theme.of(context).buttonColor,
                              child: Text(
                                e.title,
                                style: TextStyle(color: lightBG),
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0)),
                              onPressed: () {
                                songs.selected = e;
                                // songs.streamController.add(e);
                              },
                            ),
                          );
                        },
                      ),
                    ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildContents(context)),
        ],
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    return Consumer<Songs>(
      builder: (context, songs, child) {
        return BlocBuilder<SongBloc, SongState>(
          builder: (context, state) {
            if (state is SongsLoading) {
              return child;
            } else if (state is SongsLoaded) {
              final List<Song> items = state.songs;
              // if (items.isNotEmpty) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final SongLight item = new SongLight(
                      title: items[index].title, number: items[index].number);
                  return SongWidget(song: item);
                },
              );
              // }
            } else {
              return Container(
                height: 300,
                child: Center(
                  child: Text("C'è un errore 😖\nriprova tra qualche istante.",
                      textAlign: TextAlign.center),
                ),
              );
            }
          },
        );
      },
      child: Consumer<ThemeChanger>(
        builder: (context, theme, child) {
          return Shimmer.fromColors(
            // baseColor: Theme.of(context).primaryColorLight,
            // highlightColor: Theme.of(context).primaryColor,
            baseColor: theme.getThemeName() == Constants.themeLight
                ? Colors.grey[100]
                : Colors.grey[600],
            highlightColor: theme.getThemeName() == Constants.themeLight
                ? Colors.grey[300]
                : Colors.grey[900],
            child: child,
          );
        },
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
                width: MediaQuery.of(context).size.width - 35.00,
                height: 30.00,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.white,
                ),
              ),
            );
          },
          itemCount: List.generate(10, (i) => i++).length,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animation = null;
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // @override
  // Ticker createTicker(void Function(Duration elapsed) onTick) {}

  @override
  void updateKeepAlive() {}

  @override
  bool get wantKeepAlive => true;
}
