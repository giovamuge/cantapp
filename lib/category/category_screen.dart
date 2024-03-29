import 'package:cantapp/category/category_model.dart';
import 'package:cantapp/song/bloc/songs_bloc.dart';
import 'package:cantapp/song/song_search.dart';
import 'package:cantapp/widgets/list_songs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with TickerProviderStateMixin {
  bool _visible;
  ScrollController _controller;
  String _title;
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    _title = "Categorie";
    _visible = false;
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _controller = new ScrollController();
    _controller.addListener(_onScrolling);
    super.initState();
  }

  void _onScrolling() {
    // valore di offset costante
    const offset = 40;
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
  void dispose() {
    _animation = null;
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var categories = Categories.items;

    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) =>
              Opacity(opacity: _animation.value, child: child),
          child: Text(_title),
        ),
        actions: <Widget>[
          Center(
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () => showSearch(
                context: context,
                delegate: SongSearchDelegate(),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: ListView(
        controller: _controller,
        padding: EdgeInsets.symmetric(horizontal: 20),
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              _title,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, i) => ListTile(
              dense: true,
              trailing: Icon(
                Icons.chevron_right,
                size: 20.00,
              ),
              title: Text(categories[i].title),
              // enabled: categories[i].songs != null,
              onTap: () => _onNavigateCategory(context, categories[i]),
            ),
          )
        ],
      ),
    );
  }

  void _onNavigateCategory(context, category) async {
    BlocProvider.of<SongsBloc>(context)
        .songsFromCategorySearchStream(category)
        .first
        .then(
      (songs) async {
        if (songs.isNotEmpty && songs.length > 0) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ListSongsScreen(items: songs, title: category.title),
            ),
          );
        } else {
          await _showMyDialog(category);
        }
      },
    );
  }

  Future<void> _showMyDialog(
    category,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(category.title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${category.title} non ha canzoni.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Chiudi'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
