import 'package:cantapp/common/providers.dart';
import 'package:cantapp/common/route.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/services/firebase_ads_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  // static String _pkg = "bubble_tab_bar";
  // static String get pkg => Env.getPackage(_pkg);

  // Custom navigator takes a global key if you want to access the
  // navigator from outside it's widget tree subtree
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // initialaze firebase ads
    FirebaseAdsService()..initialaze();

    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        // showPerformanceOverlay: true,
        // navigatorKey: navigatorKey,
        title: 'Cantapp',
        theme: appTheme,
        localeResolutionCallback: onLocaleResolutionCallback,
        routes: appRoutes,
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
