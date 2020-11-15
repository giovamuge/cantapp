import 'package:cantapp/services/firestore_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

@immutable
class User {
  const User({
    @required this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
  });

  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;

  User.fromMap(Map maps)
      : uid = maps["uid"],
        email = maps["email"],
        photoUrl = maps["photoUrl"],
        displayName = maps["displayName"];

  User.fromFirebaseUser(FirebaseUser fu)
      : uid = fu.uid,
        email = fu.email,
        photoUrl = fu.photoUrl,
        displayName = fu.displayName;

  toJson() {
    return {
      "uid": uid,
      "email": email,
      "photoUrl": photoUrl,
      "displayName": displayName
    };
  }
}

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(UserInfo user) {
    // check if user not null
    if (user == null) return null;

    return User(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<User> signInAnonymously() async {
    final AuthResult authResult = await _firebaseAuth.signInAnonymously();
    final FirebaseUser user = authResult.user;
    // await _addUserIfNotExist(user);
    return _userFromFirebase(user);
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    return _userFromFirebase(authResult.user);
  }

  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<User> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
