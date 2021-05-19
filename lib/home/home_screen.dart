import 'package:cantapp/category/category_model.dart';
import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/shared.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/song/bloc/filtered_songs_bloc.dart';
import 'package:cantapp/song/song_search.dart';
import 'package:cantapp/song/song_item.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/utils/song_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin
    implements AutomaticKeepAliveClientMixin<HomeScreen> {
  // properties;
  bool _visible;
  ScrollController _controller;
  Animation _animation;
  AnimationController _animationController;
  Shared _shared;

  // finals
  final InAppReview _inAppReview = InAppReview.instance;

  @override
  void initState() {
    super.initState();
    _visible = false;
    _controller = ScrollController();
    _controller.addListener(_onScrolling);
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _shared = Shared();

    WidgetsBinding.instance.addPostFrameCallback(_onPostFrameCallback);
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

  void _onPostFrameCallback(Duration duration) async {
    var remindTimestamp = await _shared.getRemind();
    if (remindTimestamp == null) {
      final remindDate = DateTime.now().add(Duration(minutes: 5));
      remindTimestamp = remindDate.millisecondsSinceEpoch;
      _shared.setRemind(remindDate);
    }

    final remindeDateTime =
        DateTime.fromMillisecondsSinceEpoch(remindTimestamp);
    final isLessOrEqualRemind = remindeDateTime.isBefore(DateTime.now());

    if (isLessOrEqualRemind && await _inAppReview.isAvailable()) {
      _inAppReview.requestReview().then(
          (value) => _shared.setRemind(DateTime.now().add(Duration(days: 15))));
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
                fontSize: 35.00,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 15.00),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () => showSearch(
                context: context,
                delegate: SongSearchDelegate(),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                primary: Theme.of(context).dialogBackgroundColor,
                padding: const EdgeInsets.all(12),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: 17.00,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Cerca",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 17.00,
                    ),
                  )
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
          SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SongUtil.buildCircleServizi(context, Colors.orange),
                Text("Accordi", style: Theme.of(context).textTheme.caption),
                SizedBox(width: 10),
                SongUtil.buildCircleServizi(context, Colors.purple),
                Text("Video", style: Theme.of(context).textTheme.caption),
                SizedBox(width: 10),
                SongUtil.buildCircleServizi(context, Colors.pink),
                Text("Audio", style: Theme.of(context).textTheme.caption),
              ],
            ),
          ),
          SizedBox(height: 20),
          BlocBuilder<FilteredSongsBloc, FilteredSongsState>(
            builder: (context, state) {
              if (state is FilteredSongsLoaded) {
                final List<Category> cats = Categories.items;
                return Container(
                  height: 30.00,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cats.length,
                    itemBuilder: (context, index) {
                      final Category cat = cats[index];
                      final double paddingLeft = index == 0 ? 22.5 : 2.5;
                      final double paddingRight =
                          index == cats.length - 1 ? 22.5 : 2.5;
                      return Container(
                        padding: EdgeInsets.only(
                            left: paddingLeft, right: paddingRight),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: state.activeFilter == cat
                                ? AppTheme.accent
                                : Theme.of(context).buttonColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                          ),
                          child: Text(
                            cat.title,
                            style: TextStyle(color: AppTheme.background),
                          ),
                          onPressed: () {
                            BlocProvider.of<FilteredSongsBloc>(context)
                                .add(UpdateFilter(cat));
                            // songs.selected = e;
                            // songs.streamController.add(e);
                          },
                        ),
                      );
                    },
                  ),
                );
                // } else if (state is FilteredSongsLoading) {
                //   return CircularProgressIndicator();
              } else {
                return Container();
              }
            },
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
    return BlocBuilder<FilteredSongsBloc, FilteredSongsState>(
      builder: (context, state) {
        if (state is FilteredSongsLoading) {
          return Consumer<ThemeChanger>(
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
          );
        } else if (state is FilteredSongsLoaded) {
          final List<SongLight> items = state.songsFiltered;
          // if (items.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final SongLight item = items[index];
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
