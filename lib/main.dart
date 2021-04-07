import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cantapp/common/constants.dart';
import 'package:cantapp/common/shared.dart';
import 'package:cantapp/common/theme.dart';
import 'package:cantapp/simple_bloc_observer.dart';
import 'package:cantapp/services/firebase_ads_service.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';

import 'app.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize firebase
  await Firebase.initializeApp();

  // simple observer bloc
  Bloc.observer = SimpleBlocObserver();

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

  AppTrackingTransparency.requestTrackingAuthorization().then((status) => {
        if (status != TrackingStatus.denied)
          FirebaseAdMob.instance.initialize(appId: AdManager.appId)
      });

  runApp(MyApp(
      theme: theme,
      themeName: themeString,
      authenticationRepository: AuthenticationRepository()));
}
