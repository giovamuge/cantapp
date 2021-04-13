import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/shared.dart';
import 'package:cantapp/common/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize firebase
  await Firebase.initializeApp();

  // simple observer bloc
  // todo: da riabilitare
  // Bloc.observer = SimpleBlocObserver();

  final shared = new Shared();
  final themeString = await shared.getThemeMode() ?? Constants.themeLight;
  final theme = themeString == Constants.themeLight ? appTheme : appThemeDark;

  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    // Handle Crashlytics enabled status when not in Debug,
    // e.g. allow your users to opt-in to crash reporting.
  }

  FirebaseInAppMessaging.instance.triggerEvent("donate");
  FirebaseInAppMessaging.instance.setAutomaticDataCollectionEnabled(true);

  // Request system's tracking authorization dialog
  AppTrackingTransparency.requestTrackingAuthorization().then((status) => {
        if (status == TrackingStatus.notDetermined)
          MobileAds.instance.initialize().then((status) =>
              print('MobileAds initialization done: ${status.adapterStatuses}'))
      });

  runApp(MyApp(
      theme: theme,
      themeName: themeString,
      authenticationRepository: AuthenticationRepository()));
}
