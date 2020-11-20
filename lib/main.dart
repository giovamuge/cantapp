import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/router.dart';
import 'package:cantapp/common/shared.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/landing/landing_screen.dart';
import 'package:cantapp/locator.dart';
import 'package:cantapp/root/root.dart';
import 'package:cantapp/services/firebase_ads_service.dart';
import 'package:cantapp/services/firebase_auth_service.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/song/song_lyric.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'root/navigator_tablet.dart';
import 'services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize firebase
  // await Firebase.initializeApp();

  final shared = new Shared();
  final themeString = await shared.getThemeMode() ?? Constants.themeLight;
  final theme = themeString == Constants.themeLight ? appTheme : appThemeDark;

  setupLocator();
  runApp(MyApp(theme: theme, themeName: themeString));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  // static String _pkg = "bubble_tab_bar";
  // static String get pkg => Env.getPackage(_pkg);

  // Custom navigator takes a global key if you want to access the
  // navigator from outside it's widget tree subtree
  // GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final ThemeData _theme;
  final String _themeName;

  const MyApp({ThemeData theme, String themeName})
      : _theme = theme,
        _themeName = themeName;

  @override
  Widget build(BuildContext context) {
    // initialize firebase ads
    // FirebaseAdsService()..initialaze();
    GetIt.instance<FirebaseAdsService>()..initialaze();
    FirebaseAnalytics analytics = FirebaseAnalytics();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Favorites()),
        ChangeNotifierProvider.value(value: SongLyric(fontSize: 15.00)),
        ChangeNotifierProvider.value(value: ThemeChanger(_theme, _themeName)),
        ChangeNotifierProvider.value(
            value: Songs(databaseReference: Firestore.instance)),
        ChangeNotifierProvider.value(value: NavigatorTablet()),
      ],
      child: Consumer<ThemeChanger>(
        builder: (context, theme, child) {
          return MaterialApp(
            showPerformanceOverlay: true,
            // navigatorKey: navigatorKey,
            // debugShowCheckedModeBanner: false,
            title: 'Cantapp',
            // navigatorKey: GetIt.instance<NavigationService>().navigatorKey,
            // onGenerateRoute: generateRoute,
            theme: theme.getTheme(),
            localeResolutionCallback: onLocaleResolutionCallback,
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics),
            ],
            // routes: appRoutes,
            home: LandingScreen(child: RootScreen()),
          );
        },
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
