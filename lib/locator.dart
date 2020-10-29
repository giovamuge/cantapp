import 'package:cantapp/services/firebase_auth_service.dart';
import 'package:cantapp/services/firestore_database.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<FirestoreDatabase>(FirestoreDatabase(uid: ""));
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  // getIt.registerFactory<FirestoreDatabase>(() => FirestoreDatabase(uid: ""));
}
