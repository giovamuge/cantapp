import 'package:cantapp/song/song_item.dart';
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
  bool _visible;
  ScrollController _controller;

  @override
  void initState() {
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
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons., color: Colors.black),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        title: AnimatedOpacity(
            // If the widget is visible, animate to 0.0 (invisible).
            // If the widget is hidden, animate to 1.0 (fully visible).
            opacity: _visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 200),
            child: Text(widget.title)),
      ),
      body: ListView(
        controller: _controller,
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildListView(widget.items),
        ],
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
