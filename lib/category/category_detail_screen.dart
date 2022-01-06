import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../category/category_model.dart';
import '../song/song_model.dart';
import '../song/song_item.dart';
import '../song/bloc/songs_bloc.dart';
import '../song/utils/songs_util.dart';

class CategoryDetailScreen extends StatefulWidget {
  final Category category;
  const CategoryDetailScreen({@required this.category});

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  bool _visible;
  ScrollController _controller;
  SongsBloc _songsBloc;

  bool get _isBottom {
    if (!_controller.hasClients) return false;
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void initState() {
    _visible = false;
    _controller = new ScrollController();
    _controller.addListener(_onScrolling);
    _songsBloc = context.read<SongsBloc>();
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

    if (_isBottom && _songsBloc.state is SongsLoaded) {
      final filteredLoded = _songsBloc.state as SongsLoaded;
      final last = filteredLoded.songs.last;
      _songsBloc.add(SongsFetch(last));
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
            child: Text(widget.category.title)),
      ),
      body: ListView(
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              widget.category.title,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildListView(widget.category),
        ],
      ),
    );
  }

  Widget _buildListView(Category category) {
    return BlocBuilder<SongsBloc, SongsState>(
      builder: (context, state) {
        if (state is SongsLoading) {
          return SongUtils.buildLoader();
        } else if (state is SongsLoaded) {
          final List<SongLight> items = state.songs;
          // final int length = state.songs.length - 1;
          // if (items.isNotEmpty) {
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
          _showMyDialog(widget.category);
          return Container();
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
            TextButton(
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

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
