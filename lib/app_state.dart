import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:solution_challenge_tcu_2025/firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  late GenerativeModel model;
  geminiInit() async {
    model = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-2.0-flash',
    );
  }

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
