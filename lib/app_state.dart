import 'dart:async';
import 'package:flutter/material.dart';

class ApplicationState extends ChangeNotifier {
 
  // 表示画面選択
  int _screenId = 0;
  int oldscreenId = 0;
  int get screenId => _screenId;
  set screenId(int value) {
    _screenId = value;
    print('screenId changed to $value');
    notifyListeners();
  }

}
