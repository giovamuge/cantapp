import 'package:cantapp/common/theme.dart';
import 'package:cantapp/favorite/bloc/favorite_bloc.dart';
import 'package:cantapp/root/root.dart';
import 'package:cantapp/services/firebase_ads_service.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/bloc/songs_bloc.dart';
import 'package:cantapp/song/song_lyric.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:authentication_repository/authentication_repository.dart';

import 'authentication/authentication.dart';
import 'category/category_model.dart';
import 'landing/landing_screen.dart';
import 'root/navigator_tablet.dart';

import 'song/bloc/filtered_songs_bloc.dart';
import 'song/bloc/song_bloc.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  // static String _pkg = "bubble_tab_bar";
  // static String get pkg => Env.getPackage(_pkg);

  // Custom navigator takes a global key if you want to access the
  // navigator from outside it's widget tree subtree
  // GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  // NavigatorState get _navigator => _navigatorKey.currentState;

  final ThemeData _theme;
  final String _themeName;
  final AuthenticationRepository authenticationRepository;

  const MyApp({
    @required ThemeData theme,
    @required String themeName,
    @required this.authenticationRepository,
  })  : _theme = theme,
        _themeName = themeName;

  @override
  Widget build(BuildContext context) {
    // initialize firebase ads
    FirebaseAdsService()..initialaze();

    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider<AuthenticationBloc>(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: SongLyric(fontSize: 15.00)),
            ChangeNotifierProvider.value(
                value: ThemeChanger(_theme, _themeName)),
            ChangeNotifierProvider.value(value: NavigatorTablet()),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => SongsBloc(
                  firestoreDatabase: FirestoreDatabase(uid: ""),
                )..add(SongsFetch(null, Categories.first())),
              ),
              BlocProvider(
                create: (context) => SongBloc(
                  firestoreDatabase: FirestoreDatabase(uid: ""),
                ),
              ),
              BlocProvider<FilteredSongsBloc>(
                create: (context) => FilteredSongsBloc(
                  songsBloc: BlocProvider.of<SongsBloc>(context),
                ),
              ),
              BlocProvider<FavoriteBloc>(
                create: (context) => FavoriteBloc(
                  firestoreDatabase: FirestoreDatabase(uid: ""),
                ),
              ),
            ],
            child: Consumer<ThemeChanger>(
              builder: (context, theme, child) {
                return MaterialApp(
                  // showPerformanceOverlay: true,
                  // navigatorKey: navigatorKey,
                  debugShowCheckedModeBanner: false,
                  title: 'Cantapp',
                  // navigatorKey: GetIt.instance<NavigationService>().navigatorKey,
                  // onGenerateRoute: generateRoute,
                  theme: theme.getTheme(),
                  localeResolutionCallback: onLocaleResolutionCallback,
                  navigatorObservers: [
                    FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
                  ],
                  // routes: appRoutes,
                  home: LandingScreen(
                    authenticationRepository: authenticationRepository,
                    child: RootScreen(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Locale onLocaleResolutionCallback(
      Locale locale, Iterable<Locale> supportedLocales) {
    if (locale == null) {
      debugPrint("*language locale is null!!!");
      return supportedLocales.first;
    }

    for (Locale supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode ||
          supportedLocale.countryCode == locale.countryCode) {
        debugPrint("*language ok $supportedLocale");
        return supportedLocale;
      }
    }

    debugPrint("*language to fallback ${supportedLocales.first}");
    return supportedLocales.first;
  }
}
