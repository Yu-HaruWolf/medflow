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
                  "what is the weather today in Tokyo?",
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
                final history = [
                  Content.text('今日の東京の天気は？'),
                  Content.model([TextPart(responseText)]),
                ];
                Stream<GenerateContentResponse> responseStream = await appState
                    .model
                    .startChat(history: history)
                    .sendMessageStream(
                      Content.text("会話履歴をもとにこの地域の天気について教えてください。"),
                    );
                await for (final response in responseStream) {
                  final responseResultText = response.text;
                  if (responseResultText != null) {
                    setState(() {
                      responseText += responseResultText;
                    });
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
      'https://asia-northeast1-solution-challenge-458913.cloudfunctions.net/python-http-function?$prompt',
    );

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
}
