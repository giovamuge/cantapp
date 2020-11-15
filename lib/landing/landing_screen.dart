import 'package:cantapp/locator.dart';
import 'package:cantapp/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LandingScreen extends StatelessWidget {
  final Widget _child;
  const LandingScreen({Widget child}) : _child = child;

  @override
  Widget build(BuildContext context) {
    // var auth = Provider.of<FirebaseAuthService>(context);
    final auth = GetIt.instance<FirebaseAuthService>();
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.active) {
        User user = snapshot.data;
        if (user == null) {
          // authenticate anonymous
          // start async sign in
          auth.signInAnonymously();
        } else {
          setupLocatorFirestore(user.uid);
        }

        return _child;
        // }

        // return Scaffold(
        //   body: Center(
        //     child: Text("caricamento..."),
        //   ),
        // );
      },
    );
  }
}
