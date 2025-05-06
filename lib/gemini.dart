import 'package:flutter/foundation.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:solution_challenge_tcu_2025/function_nursing_plan.dart';
import 'package:solution_challenge_tcu_2025/function_soap.dart';

class Gemini {
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
  }

  late GenerativeModel model2;

  Future<void> geminiInit2() async {
    model2 = FirebaseVertexAI.instance.generativeModel(
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
}
