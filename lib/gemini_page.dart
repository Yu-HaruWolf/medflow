import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiPage extends StatefulWidget {
  @override
  State<GeminiPage> createState() => _GeminiPageState();
}

class _GeminiPageState extends State<GeminiPage> {
  String responseText = "Sample";

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Text(responseText),
            ElevatedButton(
              onPressed: () async {
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

                // setState(() {
                //   responseText = "";
                // });
                // 過去の会話履歴
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
NANDA-I　自己健康管理促進準備状態
目標：退院後は一人暮らしを自身で行えるようにする
O-P (観察項目)
創部の状態
床病の有無
バイタル
松葉杖の使用状態
入院中の日常生活動作
退院後、介助してくれる人がいるのか。
仕事の状況
可動域の有無
食事の状況
T-P 援助
痛みの強さの時間を確認し、緩和策を助言
退院後、電車で出社し駅から遠いため、理学療法士と協力し、リハビリ以外でも積極的に松葉杖の使用を促したり、リハビリを行ってもらう
退院後、一人暮らしのため、日常生活は自身でできるように関わる。また、家では布団で寝ついているため、自身でできないのであれば、福利用具の導入を提案する。
糖尿病があるため、栄養士と連携して食事指導を行う。
E-P（指導）
痛みは夜に強くなるようなので、食後ではなく、９時１５時、２１時で飲むようにつたえる　
出社するために早めに家を出るなど工夫してもらうように伝える
リハビリを行う。（具体的なメニューを書く）また、一人で起き上がれないため、初めて使用する用具の使い方を指導する。さらに、雨の日など傘がさせないため、カッパを使用してもらったする
糖尿病があると、創の回復が遅くなったり、感染など合併症になるリスクも指導して食事の指導をする。""";
                final history = [
                  Content.text(
                    '看護計画とSOAPの書き方について、どのような点を注意するべきか？SOAPの各項目はどのようなことですか？google 検索してまとめて',
                  ),
                  Content.model([TextPart(responseText)]),
                ];

                Stream<GenerateContentResponse> responseStream = await appState
                    .model
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
                    if (functionCall.name == 'fetchSOAPTool') {
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
  Future<void> fetchSOAP(Map<String, dynamic> soapJson) async {
    // 引数のJSONからそれぞれの値を取り出して変数に格納
    String subject = soapJson['subjective'] ?? '';
    String object = soapJson['objective'] ?? '';
    String assessment = soapJson['assessment'] ?? '';
    String plan = soapJson['plan'] ?? '';

    // ここでデータを処理することができます（例：ログに出力する）
    print('Subjective: $subject');
    print('Objective: $object');
    print('Assessment: $assessment');
    print('Plan: $plan');
  }
}
