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

class GeminiPage_nursing_plan extends StatefulWidget {
  final int patientIndex;
  const GeminiPage_nursing_plan({Key? key, required this.patientIndex})
    : super(key: key);

  @override
  State<GeminiPage_nursing_plan> createState() =>
      _GeminiPageState_nursing_plan();
}

class _GeminiPageState_nursing_plan extends State<GeminiPage_nursing_plan> {
  String responseText = "Sample";

  @override
  Widget build(BuildContext context) {
    // final appState = Provider.of<ApplicationState>(context);
    final app = Gemini();
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Text(responseText),
            ElevatedButton(
              onPressed: () async {
                print("Patient Index: ${widget.patientIndex}");
                final repo = PatientRepository();
                Patient patient = repo.getPatient(0);
                print(patient.personalInfo.name);
                final response = await fetchWeatherData(
                  "Please investigate NANDA-I usin Google search. What types of NANDA-I exist, and please tell me all the evaluation criteria for each",
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
                String soap = """【10日目】
S
「リハビリで歩く距離が伸びてきました。痛みは日中はほとんど気になりません。家で一人
でもやっていけそうな気がしてきましたが、雨の日の通勤が心配です。」
O
• 創部の状態：治癒良好、発赤・腫脹なし
• 褥瘡の有無：なし
• 体温：36.4℃
• 血圧：120/76mmHg
• 脈拍：74回/分
• 松葉杖の使用状態：院内の長距離も自立
• 入院中の日常生活動作：自立
• 退院後介助者：なし
• 仕事の状況：復職希望、通勤は電車・徒歩
• 可動域：ほぼ正常
• 食事の状況：全量摂取、間食なし
• 血糖値（朝食前）：120mg/dL
A
ADL 自立。松葉杖歩行も安定。退院後の生活に対する自信がついてきている。雨天時の移
動方法に課題あり。
P
• 雨天時の通勤対策としてカッパの使用を提案し、使い方を指導
• 必要に応じて福祉用具の導入を再検討
• 退院後もリハビリを継続できるよう理学療法士と連携
• 糖尿病管理のため食事指導を継続
""";
                String usersingPlan = """看護計画
男性：50代、前十字靭帯断裂術後　合併症に糖尿病がある。
NANDA-I　${patient.nursingPlan.nanda_i}
目標：${patient.nursingPlan.goal}
O-P (観察項目) ${patient.nursingPlan.op}

T-P 援助 ${patient.nursingPlan.tp}

E-P（指導） ${patient.nursingPlan.ep}""";

                Stream<GenerateContentResponse> responseStream1 = await app
                    .model1
                    .startChat(history: history1)
                    .sendMessageStream(
                      Content.text("""
                         会話履歴をもとに、最適で一番重要視するNANDA-Iを1つ決めてください。
                          看護記録:${soap}
                          看護計画:${usersingPlan}

                          """),
                    );
                String intermediateResponse = "";
                await for (final response in responseStream1) {
                  final responseResultText = response.text;
                  if (responseResultText != null) {
                    setState(() {
                      intermediateResponse += responseResultText;
                    });
                  }
                }
                final history2 = [
                  Content.text('最適なNANDA-Iを１つ決めてください。'),
                  Content.model([TextPart(intermediateResponse)]),
                ];

                Stream<GenerateContentResponse> responseStream = await app
                    .model1
                    .startChat(history: history2)
                    .sendMessageStream(
                      Content.text("""重要視するNANDA-Iの項目非効果的健康自己管理リスク状態となりました。

１．googel検索でこのNANDA-Iの項目における看護計画を作成し、
２．SOAPや入院時データベースから患者の個別性を加えてください。
作成する看護計画は以下の内容として、json形式で出力してください。

・O-P (観察項目)
・T-P 援助
・E-P（指導）

 看護記録:${soap}

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
                    if (functionCall.name == 'fetchNursing') {
                      // Extract the structured input data prepared by the model
                      // from the function call arguments.
                      Map<String, dynamic> nursingplanJson =
                          functionCall.args['soapJson']!
                              as Map<String, dynamic>;

                      final functionResult = await fetchNursing(
                        nursingplanJson,
                      );
                    } else {
                      Text(responseText);
                      throw UnimplementedError(
                        'Function not declared to the model: ${functionCall.name}',
                      );
                    }
                  }
                }
              },
              child: Text("看護計画を作成する"),
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
  Future<void> fetchNursing(Map<String, dynamic> soapJson) async {
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
