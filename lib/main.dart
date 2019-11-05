import 'package:cantapp/bloc_provider.dart';
import 'package:cantapp/root_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: MaterialApp(
        title: 'Cantapp',
        theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blueGrey,
            platform: Theme.of(context).platform
            // primaryColor: Colors.blue
            ),
        // home: HomeScreen(),
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
}
