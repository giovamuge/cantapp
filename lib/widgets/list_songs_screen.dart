import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/song_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListSongsScreen extends StatefulWidget {
  final String title;
  final List<Song> songListData;

  ListSongsScreen({
    @required this.songListData,
    @required this.title,
  });

  @override
  _ListSongsScreenState createState() => _ListSongsScreenState();
}

class _ListSongsScreenState extends State<ListSongsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title),
      ),
      // body: Column(
      //   mainAxisSize: MainAxisSize.max,
      //   children: <Widget>[
      // Container(
      //   color: Colors.blue,
      //   child: SearchTextField(
      //     onChanged: (value) {},
      //   ),
      // ),
      body: _buildListView(widget.songListData),

      // ],
      // ),
    );
  }

  Widget _buildListView(list) {
    return widget.songListData != null && widget.songListData.length > 0
        ? ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[500],
                  indent: 15.00,
                  thickness: .30,
                  height: 0,
                ),
            itemCount: widget.songListData.length,
            itemBuilder: (context, index) => ListTile(
                  title: Text(widget.songListData[index].title),
                  trailing: Icon(
                    FontAwesomeIcons.chevronRight,
                    size: 20.00,
                  ),
                  leading: SizedBox(
                      height: 45,
                      child: CircleAvatar(
                          child:
                              Text('$index', style: TextStyle(fontSize: 15)))),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      fullscreenDialog: true, // sono sicuro?
                      builder: (context) =>
                          SongScreen(song: widget.songListData[index]))),
                ))
        : Center(child: Text("Non ci sono preferiti ❤️"));
  }
}
