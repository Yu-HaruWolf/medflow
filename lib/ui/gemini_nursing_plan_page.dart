import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:solution_challenge_tcu_2025/data/nursing_plan.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';

import 'package:solution_challenge_tcu_2025/gemini/gemini_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiNursingPlanPage extends StatefulWidget {
  final int patientIndex;
  final GeminiService gemini;

  const GeminiNursingPlanPage({
    required this.patientIndex,
    required this.gemini,
  });

  @override
  State<GeminiNursingPlanPage> createState() => _GeminiNursingPlanPageState();
}

class _GeminiNursingPlanPageState extends State<GeminiNursingPlanPage> {
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
                Patient? patient = await repo.getPatient('0');
                print(patient!.personalInfo.name);

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

                var response_nursing_plan = await widget.gemini
                    .gemini_creat_nursing_plan(soap, usersingPlan, 0);
                print("個々の値を見たい${response_nursing_plan.nursingPlan.nanda_i}");
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
  Future<void> fetchNursing(Map<String, dynamic> nursingJson) async {
    // 引数のJSONからそれぞれの値を取り出して変数に格納
    String nanda_i = nursingJson['nanda_i'] ?? '';
    String goal = nursingJson['goal'] ?? '';
    String kansatu = nursingJson['kansatu'] ?? '';
    String ennjo = nursingJson['ennjo'] ?? '';
    String sidou = nursingJson['sidou'] ?? '';

    // ここでデータを処理することができます（例：ログに出力する）
    print('nanda_i: $nanda_i');
    print('goal: $goal');
    print('kansatu: $kansatu');
    print('ennjo: $ennjo');
    print('sidou: $sidou');

    final repo = PatientRepository();
    Patient? patient = await repo.getPatient('0');

    final newplan = NursingPlan(
      nanda_i: nanda_i,
      goal: goal,
      op: kansatu,
      tp: ennjo,
      ep: sidou,
    );

    final newPatient = Patient(
      id: patient!.id,
      nursingPlan: newplan,
      // nursingPlan は省略（null）
    );

    // final repo = PatientRepository();

    repo.updatePatient(newPatient);
    repo
        .getPatient(widget.patientIndex.toString())
        .then((patient) => print('Subject:${patient!.nursingPlan.nanda_i}'));
  }
}
