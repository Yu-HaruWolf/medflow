import 'package:flutter/foundation.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:solution_challenge_tcu_2025/function_nursing_plan.dart';

class Gemini with ChangeNotifier {
  late GenerativeModel model1;

  Future<void> geminiInit() async {
    model1 = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-2.0-flash',
      tools: [
        Tool.functionDeclarations([fetchNursingTool]),
      ],
      systemInstruction: Content.text("""
あなたは優秀な看護師です。今から退院時の看護計画を作成します。

出力の形式はjsonとし、fetchSOAPtool関数に引数として渡して、処理してください。
詳細な出力形式は以下に示す。
{
  nanda_i: ,
  目標:    ,
  観察項目:   ,
  援助:  ,
  指導:   ,
}
"""),
    );

    notifyListeners(); // 初期化が終わったら通知
  }
}
