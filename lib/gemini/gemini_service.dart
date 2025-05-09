import 'dart:convert';

import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:http/http.dart' as http;
import 'package:solution_challenge_tcu_2025/data/nursing_plan.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';

import 'gemini_tools.dart';

class GeminiService {
  late GenerativeModel model1;

  Future<void> geminiInit() async {
    // Set parameter values in a `GenerationConfig` (example values shown here)
    final generationConfig = GenerationConfig(temperature: 0.0);
    // GenerationConfigにtool_configを追加
    // 強制的に関数呼び出しを使用する設定
    // final toolConfig = ToolConfig(
    //   functionCallingConfig: FunctionCallingConfig.mode(
    //     "ANY",
    //   ), // 名前付きコンストラクタを使用
    //   // または特定の関数のみ許可する場合
    //   // functionCallingConfig: FunctionCallingConfig.modeWithAllowedFunctions("ANY", ["fetchNursing"])
    // );
    model1 = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-2.0-flash',
      generationConfig: generationConfig,
      tools: [
        Tool.functionDeclarations([fetchNursingTool]),
      ],
      systemInstruction: Content.text("""
あなたは優秀な看護師です。今から退院時の看護計画を作成します。

形式はjson形式で、以下のように出力してください。
{
  nanda_i: ,
  goal:    ,
  kansatu:   ,
  ennjo:  ,
  sidou:   ,
}
詳細な出力形式は以下に示す。
{
  nanda_i: ,
  goal:    ,
  kansatu:   ,
  ennjo:  ,
  sidou:   ,
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

  // GETリクエストを送信する関数
  Future<Map<String, dynamic>?> fetchWeatherData(String prompt) async {
    final Uri url = Uri.parse(
      'https://asia-northeast1-solution-challenge-458913.cloudfunctions.net/python-http-function',
    ).replace(queryParameters: {'prompt': prompt});
    try {
      final response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        // レスポンスが正常ならJSONデータを解析して返す
        return json.decode(response.body);
      } else {
        print('Failed to load data');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Patient> gemini_creat_nursing_plan(
    String soap,
    String nursingPlan,
    int patientId,
  ) async {
    // 1. GAEからレスポンスを取得
    String responseText = "";
    final response = await fetchWeatherData(
      "Please investigate NANDA-I usin Google search. What types of NANDA-I exist, and please tell me all the evaluation criteria for each",
    );

    if (response != null) {
      responseText = response['response']; // Cloud Functionからのレスポンス
    } else {
      responseText = "Failed to load data";
    }

    // 2. 過去の会話履歴を設定
    final history1 = [
      Content.text('NANDA-Iについて調べてください。どのようなNANDA-Iがあり、それぞれの評価項目をすべて教えてください。'),
      Content.model([TextPart(responseText)]),
    ];

    // 3. Geminiに問い合わせ
    String intermediateResponse = "";
    Stream<GenerateContentResponse> responseStream1 = await model1
        .startChat(history: history1)
        .sendMessageStream(
          Content.text("""
             会話履歴をもとに、最適で一番重要視するNANDA-Iを1つ決めてください。
              看護記録:${soap}
              看護計画:${nursingPlan}
              """),
        );

    await for (final response1 in responseStream1) {
      final response1ResultText = response1.text;
      if (response1ResultText != null) {
        intermediateResponse += response1ResultText;
      }
    }
    history1.add(Content.text('最適なNANDA-Iを決定してください。'));
    history1.add(Content.model([TextPart(intermediateResponse)]));
    String json_responseText = "";
    Stream<GenerateContentResponse> responseStream = await model1
        .startChat(history: history1)
        .sendMessageStream(
          Content.text("""
   重要視するNANDA-Iの項目は会話履歴から確認してそれを一番重視してください。

１．googel検索でこのNANDA-Iの項目における看護計画を作成し、
２．SOAPや入院時データベースから患者の個別性を加えてください。
作成する看護計画は以下の内容として、
json形式で出力してください。
{
  nanda_i:  ,
  goal:    ,
  kansatu:   ,
  ennjo:  ,
  sidou:  ,
}
・O-P (観察項目)
・T-P 援助
・E-P（指導)

 看護記録:${soap}
              """),
        );
    String accumulated_text = "";
    await for (final response in responseStream) {
      final responseResultText = response.text;
      if (responseResultText != null) {
        accumulated_text += responseResultText;
      }
    }
    final repo = PatientRepository();
    Patient? patient = await repo.getPatient(patientId.toString());
    if (patient == null) {
      throw Exception("患者ID $patientId が見つかりません");
    }

    final newplan;
    try {
      // JSON部分を正規表現で抽出
      final regex = RegExp(r'\{[\s\S]*\}');
      final match = regex.firstMatch(accumulated_text);

      if (match != null) {
        final jsonString = match.group(0)!;
        final jsonObject = jsonDecode(jsonString);
        print('抽出・パースしたJSONオブジェクト:');
        print(jsonObject);

        final newplan = NursingPlan(
          nanda_i: jsonObject['nanda_i'] ?? '',
          goal: jsonObject['goal'] ?? '',
          op: jsonObject['kansatu'] ?? '',
          tp: jsonObject['ennjo'] ?? '',
          ep: jsonObject['sidou'] ?? '',
        );

        final newPatient = Patient(
          id: patient!.id,
          nursingPlan: newplan,
          // 他の必須プロパティも設定
          // 患者の他の情報は保持する必要がある場合はここでセット
        );

        // リポジトリ経由で更新

        await repo.updatePatient(newPatient);

        return newPatient;
      } else {
        print('JSON部分が見つかりませんでした。');
      }
    } catch (e) {
      print('JSONのパースエラー: $e');
      return Patient(id: patientId.toString());
      ;
    }
    // 関数の最後に追加
    throw Exception("期待される条件が満たされていません");
    // 実際のPatientオブジェクトを作成して返す
  }
}
