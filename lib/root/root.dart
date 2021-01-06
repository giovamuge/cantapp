import 'package:cantapp/authentication/authentication.dart';
import 'package:cantapp/favorite/bloc/favorite_bloc.dart';
import 'package:cantapp/root/root_tablet.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/bloc/filtered_songs_bloc.dart';
import 'package:cantapp/song/bloc/songs_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../responsive/screen_type_layout.dart';
import 'root_mobile.dart';

class RootScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return MultiBlocProvider(
    //   providers: [
    //     BlocProvider(
    //       create: (context) => SongsBloc(
    //           // firestoreDatabase: firestoreDatabas,
    //           )
    //         ..add(SongsFetch([])),
    //     ),
    //     BlocProvider<FilteredSongsBloc>(
    //       create: (context) => FilteredSongsBloc(
    //         songsBloc: BlocProvider.of<SongsBloc>(context),
    //       ),
    //     ),
    //     BlocProvider<FavoriteBloc>(
    //       create: (context) => FavoriteBloc(
    //         firestoreDatabase: FirestoreDatabase(
    //             uid:
    //                 BlocProvider.of<AuthenticationBloc>(context).state.user.id),
    //       )..add((FavoritesLoad())),
    //     ),
    //   ],
    //   child: ScreenTypeLayout(
    //     mobile: RootScreenMobile(),
    //     tablet: RootScreenTablet(),
    //     desktop: RootScreenTablet(),
    //   ),
    // );

    return ScreenTypeLayout(
      mobile: RootScreenMobile(),
      tablet: RootScreenTablet(),
      desktop: RootScreenTablet(),
    );
  }
}
