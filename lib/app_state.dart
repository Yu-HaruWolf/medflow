import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:solution_challenge_tcu_2025/firebase_options.dart';
import 'package:solution_challenge_tcu_2025/function_soap.dart';
import 'package:solution_challenge_tcu_2025/gemini_search.dart';

class ApplicationState extends ChangeNotifier {
  late GenerativeModel model;
  geminiInit() async {
    model = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-2.0-flash',
      tools: [
        Tool.functionDeclarations([fetchSOAPTool]),
      ],
      systemInstruction: Content.text("""これは看護師と患者の会話の内容です。
この会話の内容と患者の看護計画を参照し、看護記録の記載方法の一つで、Subjective（主観的情報）、Objective（客観的情報）、Assessment（評価）、Plan（計画）をそれぞれjson形式で出力してください。
Planは今のNANDA-Iの項目でよいか。それとも新たなNANDA-Iへ以降するかを推論してください。

1. 看護計画におけるSOAPの書き方をgoogle 検索で調べる
2. SOAPにおいて重要な部分を看護計画や会話の内容から抜きだす。
3. 今の看護計画のNANDA-IにおいてSOAPがどのような書き方やどのようなことを注意するかなどGoogle Searchを行う
4. 1,2,3のステップを通してSOAPにおける注意点を考慮しながら、看護計画と会話の内容を参照してSOAPを構成する。
5. Planの部分は今の看護計画のNANDA-Iを継続か、あるいは新たなNANDA-Iに変更か。のみを記載するようにする。
6. 出力のjsonはfetchSOAPtool関数に引数として渡して、処理してください


"""),
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
