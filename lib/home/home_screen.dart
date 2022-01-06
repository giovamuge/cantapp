import 'package:cantapp/category/category_model.dart';
import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/shared.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/song/bloc/songs_bloc.dart';
import 'package:cantapp/song/song_search.dart';
import 'package:cantapp/song/song_item.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/utils/songs_util.dart';
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
  SongsBloc _songsBloc;

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

    _songsBloc = context.read<SongsBloc>();
    _songsBloc.add(UpdateFilter(Categories.first()));

    WidgetsBinding.instance.addPostFrameCallback(_onPostFrameCallback);
  }

  bool get _isBottom {
    if (!_controller.hasClients) return false;
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    return currentScroll >= (maxScroll * 0.65);
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

    if (_isBottom && _songsBloc.state is SongsLoaded) {
      final filteredLoded = _songsBloc.state as SongsLoaded;
      final last = filteredLoded.songs.last;
      _songsBloc.add(SongsFetch(last));
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
          BlocBuilder<SongsBloc, SongsState>(
            builder: (context, state) {
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
                        // da cambiare con elevated button
                        style: ElevatedButton.styleFrom(
                          primary: (state is SongsLoaded &&
                                      state.activeFilter == cat) ||
                                  (state is SongsLoading &&
                                      state.activeFilter == cat)
                              // MaterialStateProperty.all(AppTheme.accent)
                              ? Colors.orangeAccent
                              : Theme.of(context).buttonColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: Text(
                          cat.title,
                          style: TextStyle(color: AppTheme.background),
                        ),
                        onPressed: () {
                          BlocProvider.of<SongsBloc>(context)
                              .add(UpdateFilter(cat));
                          // songs.selected = e;
                          // songs.streamController.add(e);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildContents(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    return BlocBuilder<SongsBloc, SongsState>(
      builder: (context, state) {
        if (state is SongsLoading) {
          return _buildLoader();
        } else if (state is SongsLoaded) {
          final List<SongLight> items = state.songs;
          // final int length = state.songs.length - 1;
          if (items.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.hasReachedMax
                  ? state.songs.length
                  : state.songs.length + 1,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                // final SongLight item = items[index];
                return index >= state.songs.length
                    ? SongUtils.buildLoader()
                    : SongWidget(song: items[index]);
              },
            );
          } else {
            return Container(
              height: 300,
              child: Center(
                child: Text(
                  "Non ci sono canti.",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
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

  Widget _buildLoader() {
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
        itemCount: List.generate(15, (i) => i++).length,
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

  @override
  void updateKeepAlive() {}

  @override
  bool get wantKeepAlive => true;
}
