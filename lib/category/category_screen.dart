import 'package:cantapp/category/category_model.dart';
import 'package:cantapp/home/home_screen.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/widgets/list_songs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class CategoryScreen extends StatefulWidget {
//   @override
//   _CategoryScreenState createState() => _CategoryScreenState();
// }

class CategoryScreen extends StatelessWidget {
  // Categories _categoriesData;
  // Songs _songsData;

  @override
  Widget build(BuildContext context) {
    var categoriesData = Provider.of<Categories>(context);
    var songsData = Provider.of<Songs>(context);
    categoriesData.fetchSongsToCategories(songsData.items);
    var categories = categoriesData.items;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TitleWidget(
              "Cantapp",
              padding: const EdgeInsets.only(
                  top: 30, left: 15, right: 15, bottom: 15),
            ),
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
                enabled: categories[i].songs != null,
                onTap: () {
                  // print(categories[i].songs);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategorySongsScreen(
                        songs: categories[i].songs,
                        title: categories[i].title,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget _buildListView(List<Category> categories) {
  //   // var categories = _categoriesData.items;
  //   if (categories == null || categories.length == 0)
  //     return Center(
  //       child: Text("Non ci sono categorie"),
  //     );
  //   else
  //     return ;
  // }
}

class CategorySongsScreen extends StatelessWidget {
  final String title;
  final List<Song> songs;

  CategorySongsScreen({this.songs, this.title});

  @override
  Widget build(BuildContext context) {
    return ListSongsScreen(
      items: songs,
      title: title,
    );
  }
}
