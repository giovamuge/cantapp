import 'package:cantapp/song/bloc.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  SongBloc _songBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _songBloc = BlocProvider.of<SongBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        if (state is SongUninitialized) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is SongError) {
          return Center(
            child: Text('failed to fetch songs'),
          );
        }
        if (state is SongLoaded) {
          if (state.songs.isEmpty) {
            return Center(
              child: Text('no songs'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.songs.length
                  ? BottomLoader()
                  : SongWidget(song: state.songs[index], number: index);
            },
            itemCount: state.hasReachedMax
                ? state.songs.length
                : state.songs.length + 1,
            controller: _scrollController,
          );
        }

        return Center(
          child: Text("Non esistono canzoni"),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _songBloc.add(Fetch());
    }
  }
}

class SongWidget extends StatelessWidget {
  final Song song;
  final int number;

  const SongWidget({Key key, @required this.song, @required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('$number. ${song.title}'),
      // isThreeLine: true,
      // subtitle: Text("Prova"),
      dense: true,
    );
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
