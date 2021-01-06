import 'package:authentication_repository/authentication_repository.dart';
import 'package:cantapp/authentication/bloc/authentication_bloc.dart';
import 'package:cantapp/favorite/bloc/favorite_bloc.dart';
import 'package:cantapp/locator.dart';
import 'package:cantapp/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

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
    // var auth = Provider.of<FirebaseAuthService>(context);
    // final auth = GetIt.instance<FirebaseAuthService>();

    // return StreamBuilder(
    //   stream: auth.onAuthStateChanged,
    //   builder: (context, snapshot) {
    //     // if (snapshot.connectionState == ConnectionState.active) {
    //     User user = snapshot.data;
    //     if (user == null) {
    //       // authenticate anonymous
    //       // start async sign in
    //       auth.signInAnonymously();
    //     } else {
    //       setupLocatorFirestore(user.uid);
    //     }

    //     return _child;
    //     // }

    //     // return Scaffold(
    //     //   body: Center(
    //     //     child: Text("caricamento..."),
    //     //   ),
    //     // );
    //   },
    // );

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
