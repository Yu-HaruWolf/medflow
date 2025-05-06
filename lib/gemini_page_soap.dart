import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge_tcu_2025/data/nursing_plan.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';

import 'package:solution_challenge_tcu_2025/data/soap.dart';
import 'package:solution_challenge_tcu_2025/gemini.dart';
import 'app_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiPage_soap extends StatefulWidget {
  final int patientIndex;
  final Gemini gemini;

  const GeminiPage_soap({required this.patientIndex, required this.gemini});

  @override
  State<GeminiPage_soap> createState() => _GeminiPageState_soap();
}

class _GeminiPageState_soap extends State<GeminiPage_soap> {
  String responseText = "Sample";

  @override
  Widget build(BuildContext context) {
    // final appState = Provider.of<ApplicationState>(context);

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Text(responseText),
            ElevatedButton(
              onPressed: () async {
                print("Patient Index: ${widget.patientIndex}");
                // ⭐ model1 の初期化を忘れずに
                await widget.gemini.geminiInit();
                final repo = PatientRepository();
                Patient patient = repo.getPatient(0);
                print(patient.personalInfo.name);
                final response = await fetchWeatherData(
                  "Please tell me the points to be aware of when writing nursing care plans and SOAP notes. What does each section of SOAP entail? Please summarize after conducting a Google search.Points to Consider When Writing Nursing Care Plans?",
                );
                if (response != null) {
                  setState(() {
                    responseText =
                        response['response']; // Cloud Functionからのレスポンスを更新
                  });
                } else {
                  setState(() {
                    responseText = "Failed to load data";
                  });
                }
                // 過去の会話履歴
                final history1 = [
                  Content.text(
                    'NANDA-Iについて調べてください。どのようなNANDA-Iがあり、それぞれの評価項目をすべて教えてください。',
                  ),
                  Content.model([TextPart(responseText)]),
                ];

                // setState(() {
                //   responseText = "";
                // });
                String userConversation = """看護師：「こんにちは。今日の体調はいかがですか？」
患者：「まあまあですけど、夜になると膝がズキズキして眠れないことがあります。」
看護師：「夜の痛みが強いんですね。どのくらいの痛みですか？例えば、10 段階で表すと？」
患者：「夜は7 くらいです。昼間は3 くらいかな。」
看護師：「ありがとうございます。痛み止めは今、食後に飲んでいますか？」
患者：「はい、食後に飲んでいます。」
看護師：「夜の痛みが強いので、薬の飲み方を 9 時、15 時、21 時に変えてみましょうか。」
患者：「それなら夜も少し楽になるかもしれませんね。」
看護師：「退院後はご自宅で一人暮らしですが、不安なことはありますか？」
患者：「布団から起き上がるのが大変そうで...。あと、駅まで歩くのも心配です。」
看護師：「布団からの起き上がり方や、必要であれば福祉用具の導入も考えましょう。駅ま
での移動は理学療法士と一緒に練習しましょうね。」
患者：「はい、お願いします。」
看護師：「食事や血糖値の管理で困っていることはありませんか？」
患者：「つい間食してしまうので、どうしたらいいか...。」
看護師：「栄養士と一緒に食事の工夫を考えましょう。糖尿病があると傷の治りも遅くなる
ので、気をつけていきましょうね。」
患者：「わかりました。」""";
                String usersingPlan = """看護計画
男性：50代、前十字靭帯断裂術後　合併症に糖尿病がある。
NANDA-I　${patient.nursingPlan.nanda_i}
目標：${patient.nursingPlan.goal}
O-P (観察項目) ${patient.nursingPlan.op}

T-P 援助 ${patient.nursingPlan.tp}

E-P（指導） ${patient.nursingPlan.ep}""";
                final history = [
                  Content.text(
                    '看護計画とSOAPの書き方について、どのような点を注意するべきか？SOAPの各項目はどのようなことですか？google 検索してまとめて',
                  ),
                  Content.model([TextPart(responseText)]),
                ];

                Stream<GenerateContentResponse> responseStream = await widget
                    .gemini
                    .model2
                    .startChat(history: history)
                    .sendMessageStream(
                      Content.text("""
                          以下の内容と会話履歴のSOAPの書き方について考慮しながら、SOAPの内容を抽出してください。fetchSOAP関数を呼び出してください。
                          会話:${userConversation}
                          看護計画:${usersingPlan}

                          """),
                    );
                await for (final response in responseStream) {
                  final responseResultText = response.text;
                  if (responseResultText != null) {
                    setState(() {
                      responseText += responseResultText;
                    });
                  }

                  final functionCalls = response.functionCalls.toList();
                  if (functionCalls.isNotEmpty) {
                    final functionCall = functionCalls.first;
                    if (functionCall.name == 'fetchSOAP') {
                      // Extract the structured input data prepared by the model
                      // from the function call arguments.
                      Map<String, dynamic> soapJson =
                          functionCall.args['soapJson']!
                              as Map<String, dynamic>;

                      final functionResult = await fetchSOAP(soapJson);
                    } else {
                      Text(responseText);
                      throw UnimplementedError(
                        'Function not declared to the model: ${functionCall.name}',
                      );
                    }
                  }
                }
              },
              child: Text("SOAPを作成する"),
            ),
          ],
        ),
      ),
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

  // This function calls a hypothetical external API that returns
  // a collection of weather information for a given location on a given date.
  // `location` is an object of the form { city: string, state: string }
  Future<void> fetchSOAP(Map<String, dynamic> soapJson) async {
    // 引数のJSONからそれぞれの値を取り出して変数に格納
    String nanda_i = soapJson['nanda_i'] ?? '';
    String goal = soapJson['goal'] ?? '';
    String kansatu = soapJson['kansatu'] ?? '';
    String ennjo = soapJson['ennjo'] ?? '';
    String sidou = soapJson['sidou'] ?? '';

    // ここでデータを処理することができます（例：ログに出力する）
    print('nanda_i: $nanda_i');
    print('goal: $goal');
    print('kansatu: $kansatu');
    print('ennjo: $ennjo');
    print('sidou: $sidou');
    final newplan = NursingPlan(
      nanda_i: nanda_i,
      goal: goal,
      op: kansatu,
      tp: ennjo,
      ep: sidou,
    );
    final newPatient = Patient(
      nursingPlan: newplan,
      // nursingPlan は省略（null）
    );

    final repo = PatientRepository();

    repo.updatePatient(widget.patientIndex, newPatient);
    Patient patient1 = repo.getPatient(widget.patientIndex);
    print('Subject:${patient1.nursingPlan.nanda_i}');
  }
}
