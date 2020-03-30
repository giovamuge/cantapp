import 'package:cantapp/common/theme.dart';
import 'package:cantapp/favorite/favorite.dart';
import 'package:cantapp/root_screen.dart';
import 'package:cantapp/song/song_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared/env.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  static String _pkg = "bubble_tab_bar";
  static String get pkg => Env.getPackage(_pkg);

  final Firestore _databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getProviders(),
      child: MaterialApp(
        title: 'Cantapp',
        theme: appTheme,
        home: RootScreen(),
        localeResolutionCallback: onLocaleResolutionCallback,
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

  List<SingleChildWidget> getProviders() {
    return [
      // ChangeNotifierProvider.value(value: Categories()),
      ChangeNotifierProvider.value(value: Favorites()),
      ChangeNotifierProvider.value(
          value: Songs(databaseReference: _databaseReference))
      // ChangeNotifierProvider<Categories>(
      //   create: (_) => Categories(),
      // ),
      // ChangeNotifierProvider<Favorites>(create: (_) => Favorites()),
      // ChangeNotifierProvider<Songs>(
      //     create: (_) => Songs(databaseReference: _databaseReference))
    ];
  }
}
