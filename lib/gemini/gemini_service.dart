import 'dart:convert';

import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:http/http.dart' as http;
import 'package:solution_challenge_tcu_2025/data/nursing_plan.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';
import 'package:solution_challenge_tcu_2025/data/soap.dart';

import 'gemini_tools.dart';

class GeminiService {
  late GenerativeModel model1;
  late GenerativeModel model2;
  late GenerativeModel model3;

  void geminiInit() {
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

    model2 = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-2.0-flash',
      tools: [
        Tool.functionDeclarations([fetchSOAPTool]),
      ],
      systemInstruction: Content.text("""
これは看護師と患者の会話の内容です。
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

    model3 = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-2.0-flash',
      systemInstruction: Content.text("""あなたは優秀な看護師です。今から退院時の看護計画を作成します。
1.患者の情報や病床から重大な最重要項目であるNANDA-Iを１つ決めます。
2. その後NANDA-Iにそった看護計画を作成します。
3. 患者の情報やSoapの内容、看護師のメモ書きなどを参考に最適なNANDA-Iを作成してください。

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
}"""),
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

  Future<NursingPlan> gemini_create_nursing_plan(
    Patient patient,
    NursingPlan nursingplan,
    Soap soap,
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
            患者の情報から今回の病床を把握して、一番重要視するNANDA-Iを1つ決めてください。
            このとき、看護計画やSOAPの内容、メモなどから今の患者に最適なNANDA-I１つ決めてください。
            NANDA-Iの決定には会話履歴のNANDA-Iの項目や評価項目を参照し、最適なものを推論してください。
              患者情報:${patient.toJson()}

              以下は記載がある場合は、今の患者の病床と大きく異なる場合があるので、大きく参考にしてください
              看護計画:${nursingplan.toJson()}
              SOAP:${soap.toJson()}
              メモ：{}
              
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
２．SOAPや入院時データベースから患者の個別性(患者の職業や家族構成など）を加えてください。
作成する看護計画は以下の内容として、
json形式で必ず出力してください。
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
              患者情報:${patient.toJson()}

              以下は記載がある場合は、今の患者の病床と大きく異なる場合があるので、大きく参考にしてください
              看護計画:${nursingplan.toJson()}
              SOAP:${soap.toJson()}
              メモ：{}
              
              """),
        );
    String accumulated_text = "";
    await for (final response in responseStream) {
      final responseResultText = response.text;
      if (responseResultText != null) {
        accumulated_text += responseResultText;
      }
    }
    print(accumulated_text);
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

        return newplan;
      } else {
        print('JSON部分が見つかりませんでした。');
      }
    } catch (e) {
      print('JSONのパースエラー: $e');
      return nursingplan;
      ;
    }
    // 関数の最後に追加
    throw Exception("期待される条件が満たされていません");
    // 実際のPatientオブジェクトを作成して返す
  }

  Future<Soap> gemini_create_soap(
    Patient patient,
    NursingPlan nursingplan,
    Soap soap,
    String todaysoap,
  ) async {
    // 1. GAEからレスポンスを取得
    String responseText = "";
    final response = await fetchWeatherData(
      "Please tell me the points to be aware of when writing nursing care plans and SOAP notes. What does each section of SOAP entail? Please summarize after conducting a Google search.Points to Consider When Writing Nursing Care Plans?",
    );

    if (response != null) {
      responseText = response['response']; // Cloud Functionからのレスポンス
    } else {
      responseText = "Failed to load data";
    }

    final history = [
      Content.text(
        '看護計画とSOAPの書き方について、どのような点を注意するべきか？SOAPの各項目はどのようなことですか？google 検索してまとめて',
      ),
      Content.model([TextPart(responseText)]),
    ];
    String json_responseText = "";
    Stream<GenerateContentResponse> responseStream = await model2
        .startChat(history: history)
        .sendMessageStream(
          Content.text("""
    会話履歴をもとにSOAPを書く際の項目や注意点を考慮してSOAPを教えてください
    患者情報、看護計画、前日のSOAPの内容を参考に今日のSOAPを作成してください。
    例）前日に痛みなどがある場合は、その部分について今日のSOAPに反映して作成してください

    本日のSOAPの情報は以下の通りです。
    ${todaysoap}

    患者情報:${patient.toJson()}
    看護計画:${nursingplan.toJson()}
    SOAP:${soap.toJson()}
    SOAPの内容を抽出してください。json形式で出力してください。
    {
  subject:  ,
  object:    ,
  assessment:   ,
  plan:  ,
}

              """),
        );

    String accumulated_text = "";
    await for (final response in responseStream) {
      final responseResultText = response.text;
      if (responseResultText != null) {
        accumulated_text += responseResultText;
      }
    }

    final newsoap;
    try {
      // JSON部分を正規表現で抽出
      final regex = RegExp(r'\{[\s\S]*\}');
      final match = regex.firstMatch(accumulated_text);

      if (match != null) {
        final jsonString = match.group(0)!;
        final jsonObject = jsonDecode(jsonString);
        print('抽出・パースしたJSONオブジェクト:');
        print(jsonObject);

        newsoap = Soap(
          subject: jsonObject['subjective'] ?? '',
          object: jsonObject['objective'] ?? '',
          assessment: jsonObject['assessment'] ?? '',
          plan: jsonObject['plan'] ?? '',
        );

        // リポジトリ経由で更新

        // await repo.updatePatient(newPatient);

        return newsoap;
      } else {
        print('JSON部分が見つかりませんでした。');
      }
    } catch (e) {
      print('JSONのパースエラー: $e');
      return soap;
    }
    // 関数の最後に追加
    throw Exception("期待される条件が満たされていません");
  }
}
