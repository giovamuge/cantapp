import 'package:cantapp/services/firebase_ads_service.dart';
import 'package:cantapp/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  // locator.registerSingleton<FirestoreDatabase>(FirestoreDatabase(uid: ""));
  locator.registerSingleton<NavigationService>(NavigationService());
  locator.registerSingleton<FirebaseAdsService>(FirebaseAdsService());

  // esempio di register factory
  // potrebbe essere una soluzione
  // getIt.registerFactory<FirestoreDatabase>(() => FirestoreDatabase(uid: ""));
}

void setupLocatorFirestore(String uid) {
  // locator.unregister<FirestoreDatabase>();
  // locator.registerSingleton<FirestoreDatabase>(FirestoreDatabase(uid: uid));
}
