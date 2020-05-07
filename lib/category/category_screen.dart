import 'package:cantapp/category/category_model.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/song_search.dart';
import 'package:cantapp/widgets/list_songs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool _visible;
  ScrollController _controller;
  String _title;

  @override
  void initState() {
    _title = "Categorie";
    _visible = false;
    _controller = new ScrollController();
    _controller.addListener(_onScrolling);
    super.initState();
  }

  void _onScrolling() {
    // Mostra il bottone search quando raggiungo
    // 100 di altezza del title (impostazione custom)
    if (_controller.offset <= 40 && _visible) {
      setState(() => _visible = false);
    }

    // Nascondi in caso contrario
    // Controllo su _visible per non ripete il set continuamente
    if (_controller.offset > 40 && !_visible) {
      setState(() => _visible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var categories = Categories().items;

    return Scaffold(
      appBar: AppBar(
        title: AnimatedOpacity(
            // If the widget is visible, animate to 0.0 (invisible).
            // If the widget is hidden, animate to 1.0 (fully visible).
            opacity: _visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 200),
            child: Text(_title)),
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

  _onNavigateCategory(context, category) =>
      Provider.of<FirestoreDatabase>(context, listen: false)
          .songsFromCategorySearchStream(category: category)
          .listen((songs) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ListSongsScreen(items: songs, title: category.title))));
}
