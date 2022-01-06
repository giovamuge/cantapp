import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/extensions/string.dart';
import 'package:cantapp/favorite/bloc/favorite_bloc.dart';
import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/favorite/favorite_screen.dart';
import 'package:cantapp/responsive/device_screen_type.dart';
import 'package:cantapp/responsive/responsive_utils.dart';
import 'package:cantapp/root/navigator_tablet.dart';
import 'package:cantapp/services/firestore_path.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cantapp/song/song_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'utils/song_util.dart';

class SongWidget extends StatelessWidget {
  final SongLight song;
  final Function(BuildContext) _onNavigateSong;
  final Function(BuildContext) _onCallback;

  // static const Color _defaultPrimaryColor = Theme.of(context).primaryColor;

  const SongWidget({
    Key key,
    @required this.song,
    avatarColor,
    textColor,
    onNavigateSong,
    onCallback,
  })  : _onNavigateSong = onNavigateSong,
        _onCallback = onCallback,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: key,
      selectedTileColor: Theme.of(context).accentColor,
      leading: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Color(0xFF48639C), //_avatarColor[100]
        ),
        child: Center(
          child: Text(
            '${song.number}',
            style: TextStyle(
                color: Color(0xFFFFFFFF), //_avatarColor[900],
                fontWeight: FontWeight.w800,
                fontSize: 11),
          ),
        ),
      ),
      title: Text(
        '${song.title}',
        maxLines: 2,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            // color: _textColor[900],
            color: Theme.of(context).primaryColor,
            fontSize: 15),
      ),
      subtitle: Container(
        // child: Row(children: _buildSubtitle(context)),
        child: _buildSubtitle(context),
      ),
      // isThreeLine: true,
      dense: true, // TODO: sicuro?
      onTap: () => _navigateToSong(context, song),
      trailing: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () => _settingModalBottomSheet(context, song.id, context),
      ),
    );
  }

  Row _buildSubtitle(context) {
    final offsetNeeded = song.isChord ? Offset(-10, 0) : Offset(0, 0);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (song.isChord) SongUtil.buildCircleServizi(context, Colors.orange),
        if (song.links.any((l) => l.type == 'youtube'))
          Transform.translate(
            offset: offsetNeeded,
            child: SongUtil.buildCircleServizi(context, Colors.purple),
          ),
        if (song.links.any((l) => l.type == 'audio'))
          Transform.translate(
            offset: offsetNeeded,
            child: SongUtil.buildCircleServizi(context, Colors.pink),
          ),
        Flexible(
          child: Container(
            // margin: const EdgeInsets.only(left: 2),
            child: Text(
                !song.artist.isNullOrEmpty()
                    ? song.artist
                    : 'Artista conosciuto',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11)),
          ),
        ),
      ],
    );
  }

  Future<void> _settingModalBottomSheet(
      contextScaffold, songId, context) async {
    return await showModalBottomSheet(
        context: contextScaffold,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: Theme.of(context).dialogBackgroundColor,
                  width: constraints.maxWidth,
                  height: 200,
                  child: StreamBuilder<String>(
                    stream: BlocProvider.of<FavoriteBloc>(context)
                        .favoriteIdFromSongStream(songId),
                    builder: (context, data) {
                      if (data.connectionState != ConnectionState.waiting) {
                        final exist = data.hasData;
                        return Wrap(
                          children: <Widget>[
                            if (exist)
                              ListTile(
                                leading: Icon(Icons.favorite),
                                title: Text("Rimuovi preferito"),
                                onTap: () async {
                                  BlocProvider.of<FavoriteBloc>(context)
                                      .add(RemoveFavoriteFromSong(song.id));
                                  Navigator.of(context).pop();
                                  await _messageSnackbar(
                                      contextScaffold, OptionSong.remove);
                                },
                              ),
                            if (!exist)
                              ListTile(
                                leading: Icon(Icons.favorite_border),
                                title: Text("Aggiungi preferito"),
                                onTap: () async {
                                  final newFavorite = FavoriteFire(
                                    createdAt: DateTime.now(),
                                    songId: song.id,
                                    song: FirebaseFirestore.instance
                                        .doc(FirestorePath.song(song.id)),
                                  );
                                  BlocProvider.of<FavoriteBloc>(context)
                                      .add(AddFavorite(newFavorite));
                                  Navigator.of(context).pop();
                                  await _messageSnackbar(
                                      contextScaffold, OptionSong.add);
                                },
                              ),
                            ListTile(
                              leading: Icon(Icons.book),
                              title: Text("Visualizza canto"),
                              onTap: () => _navigateToSong(context, song),
                            ),
                            ListTile(
                              leading: Icon(Icons.cancel),
                              title: Text("Annulla"),
                              onTap: () => Navigator.of(context).pop(),
                            )
                          ],
                        );
                      } else {
                        final sizeWidth = MediaQuery.of(context).size.width;
                        var theme =
                            Provider.of<ThemeChanger>(context, listen: false);

                        return Shimmer.fromColors(
                          // baseColor: Theme.of(context).primaryColorLight,
                          // highlightColor: Theme.of(context).primaryColor,
                          baseColor:
                              theme.getThemeName() == Constants.themeLight
                                  ? Colors.grey[100]
                                  : Colors.grey[600],
                          highlightColor:
                              theme.getThemeName() == Constants.themeLight
                                  ? Colors.grey[300]
                                  : Colors.grey[900],
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
                                  width: sizeWidth - 35.00,
                                  height: 30.00,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                            itemCount: List.generate(3, (i) => i++).length,
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        });
  }

  _messageSnackbar(BuildContext context, OptionSong option) {
    String msg;
    if (option == OptionSong.add) {
      msg = '${song.title} ❤️ aggiunto ai preferiti';
    } else {
      msg = '${song.title} 💔 rimosso dai preferiti';
    }
    SnackBar snackBar = SnackBar(
      backgroundColor: AppTheme.secondary,
      elevation: 5,
      behavior: SnackBarBehavior.floating,
      content: Text(msg),
      action: option == OptionSong.remove
          ? null
          : SnackBarAction(
              label: 'visualizza',
              textColor: AppTheme.primary,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FavoriteScreen()),
              ),
            ),
    );

    // Scaffold.of(context).showSnackBar(snackBar);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _navigateToSong(context, song) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final DeviceScreenType device = getDeviceType(mediaQuery);

    if (device == DeviceScreenType.Mobile) {
      // chiama call back su click canzone
      _onCallback?.call(context);

      Navigator.of(context).push(
        MaterialPageRoute(
            // fullscreenDialog: true, // sono sicuro?
            builder: (context) => SongScreen(id: song.id)),
      );
      // GetIt.instance<NavigationService>()
      //     .navigateTo(songRoute, arguments: song.id);
    } else {
      Provider.of<NavigatorTablet>(context, listen: false).view =
          SongScreen(id: song.id);

      // chiama call back su click canzone
      _onCallback?.call(context);
      _onNavigateSong?.call(context);
    }
  }
}

enum OptionSong { add, remove, view }
