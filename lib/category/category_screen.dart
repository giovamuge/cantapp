import 'package:cantapp/category/category_model.dart' as cat;
import 'package:cantapp/song/song_search.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/widgets/list_songs_screen.dart';
import 'package:cantapp/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // Categories _categoriesData;
  Songs _songsData;
  bool _visible;
  ScrollController _controller;
  String _title;

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();

    _songsData = Provider.of<Songs>(context);
    // _categoriesData = Provider.of<Categories>(context);
    // await _categoriesData.fetchSongsToCategories(_songsData.items);
  }

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
    if (_controller.offset <= 80 && _visible) {
      setState(() => _visible = false);
    }

    // Nascondi in caso contrario
    // Controllo su _visible per non ripete il set continuamente
    if (_controller.offset > 80 && !_visible) {
      setState(() => _visible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var categories = cat.Categories().items;

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
                delegate: SongSearchDelegate(songsData: _songsData),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: ListView(
        controller: _controller,
        padding: EdgeInsets.symmetric(horizontal: 20),
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
              onTap: () {
                // print(categories[i].songs);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ListSongsScreen(
                        items: _songsData.findByCategory(categories[i]),
                        title: categories[i].title,
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );

    // return Scaffold(
    //   body: SingleChildScrollView(
    //     child: Column(
    //       mainAxisSize: MainAxisSize.max,
    //       children: <Widget>[
    //         TitleWidget(
    //           "Categoria",
    //           padding: const EdgeInsets.only(
    //               top: 30, left: 15, right: 15, bottom: 15),
    //         ),
    //         ListView.builder(
    //           shrinkWrap: true,
    //           physics: const NeverScrollableScrollPhysics(),
    //           itemCount: categories.length,
    //           itemBuilder: (context, i) => ListTile(
    //             dense: true,
    //             trailing: Icon(
    //               Icons.chevron_right,
    //               size: 20.00,
    //             ),
    //             title: Text(categories[i].title),
    //             // enabled: categories[i].songs != null,
    //             onTap: () {
    //               // print(categories[i].songs);

    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (context) {
    //                     return ListSongsScreen(
    //                       items: _songsData.findByCategory(categories[i]),
    //                       title: categories[i].title,
    //                     );
    //                   },
    //                 ),
    //               );
    //             },
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
