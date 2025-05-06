import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

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
                setState(() {
                  responseText = "";
                });

                Stream<GenerateContentResponse> responseStream = await appState
                    .model
                    .startChat()
                    .sendMessageStream(Content.text("長文で自己紹介をしてください。"));
                await for (final response in responseStream) {
                  final responseResultText = response.text;
                  if (responseResultText != null) {
                    setState(() {
                      responseText += responseResultText;
                    });
                  }
                }
              },
              child: Text("button"),
            ),
          ],
        ),
      ),
    );
  }
}
