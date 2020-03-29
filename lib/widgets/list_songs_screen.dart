import 'package:cantapp/home/home_screen.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:flutter/material.dart';

class ListSongsScreen extends StatefulWidget {
  final String title;
  final List<Song> items;

  ListSongsScreen({
    @required this.items,
    @required this.title,
  });

  @override
  _ListSongsScreenState createState() => _ListSongsScreenState();
}

class _ListSongsScreenState extends State<ListSongsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TitleWidget(
              widget.title,
              padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
            ),
            SizedBox(height: 15),
            _buildListView(widget.items),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<Song> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return SongWidget(song: items[index], number: index);
      },
      itemCount: items.length,
    );
  }
}
