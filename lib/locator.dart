import 'package:cantapp/services/firebase_auth_service.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:cantapp/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<FirestoreDatabase>(FirestoreDatabase(uid: ""));
  locator.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  locator.registerSingleton<NavigationService>(NavigationService());

  // esempio di register factory
  // potrebbe essere una soluzione
  // getIt.registerFactory<FirestoreDatabase>(() => FirestoreDatabase(uid: ""));
}

void setupLocatorFirestore(String uid) {
  locator.unregister<FirestoreDatabase>();
  locator.registerSingleton<FirestoreDatabase>(FirestoreDatabase(uid: uid));
}
