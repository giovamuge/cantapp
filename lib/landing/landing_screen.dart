import 'package:authentication_repository/authentication_repository.dart';
import 'package:cantapp/authentication/bloc/authentication_bloc.dart';
import 'package:cantapp/favorite/bloc/favorite_bloc.dart';
import 'package:cantapp/services/full_text_search/full_text_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingScreen extends StatelessWidget {
  final Widget _child;
  final AuthenticationRepository _authenticationRepository;

  const LandingScreen({
    AuthenticationRepository authenticationRepository,
    Widget child,
  })  : _authenticationRepository = authenticationRepository,
        _child = child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthenticationStatus.authenticated:
            //ignore: close_sinks
            // final FavoriteBloc favoriteBloc =
            //     BlocProvider.of<FavoriteBloc>(context);

            // favoriteBloc.add(UpdateAuthId(state.user.id));
            // favoriteBloc.add(FavoritesLoad());

            BlocProvider.of<FavoriteBloc>(context)
              ..add(UpdateAuthId(state.user.id))
              ..add(FavoritesLoad());

            FullTextSearch.instance.fetchFromFirestore(state.user.id, 'v1');

            // errore strano di bloc
            // final SongsBloc sbloc = BlocProvider.of<SongsBloc>(context);
            // sbloc.add(UpdateAuthIdSong(state.user.id));
            // sbloc.add(SongsFetch([]));
            // ..add(songsBloc.UpdateAuthId(state.user.id));
            // ..add(songsBloc.SongsFetch([]));

            return _child;
            break;
          case AuthenticationStatus.unauthenticated:
            _authenticationRepository.signInAnonymously();
            return Container();
            break;
          default:
            return Scaffold(
              body: Center(
                child: Text("caricamento..."),
              ),
            );
            break;
        }
      },
    );
  }
}
