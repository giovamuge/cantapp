import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class User {
  const User({
    required this.uid,
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

  User.fromFirebaseUser(auth.User fu)
      : uid = fu.uid,
        email = fu.email,
        photoUrl = fu.photoURL,
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
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  User _userFromFirebase(auth.User user) {
    // check if user not null
    if (user == null) return null;

    return User(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<User> signInAnonymously() async {
    final auth.UserCredential authResult =
        await _firebaseAuth.signInAnonymously();
    final auth.User user = authResult.user;
    // await _addUserIfNotExist(user);
    return _userFromFirebase(user);
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final auth.UserCredential authResult =
        await _firebaseAuth.signInWithCredential(
            EmailAuthProvider.credential(email: email, password: password));
    return _userFromFirebase(authResult.user);
  }

  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final auth.UserCredential authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  User currentUser() {
    final auth.User user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
