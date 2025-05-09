import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ApplicationState extends ChangeNotifier {
  // 表示画面選択
  int _screenId = 0;
  int oldscreenId = 0;
  int get screenId => _screenId;
  set screenId(int value) {
    oldscreenId = _screenId;
    _screenId = value;
    print('screenId changed to $value');
    print('oldId to $oldscreenId');
    notifyListeners();
  }
}

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
