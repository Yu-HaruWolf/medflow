import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthState extends ChangeNotifier {
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  void firebaseAuthListenerInit() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        _loggedIn = false;
        notifyListeners();
      } else {
        print('User is logged in!');
        _loggedIn = true;
        notifyListeners();
      }
    });
  }
}
