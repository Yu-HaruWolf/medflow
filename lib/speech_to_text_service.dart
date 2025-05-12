import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class SpeechToTextService {
  final _audioRecorder = AudioRecorder();
  String _filePath = '';
  final String apiKey = dotenv.env['GOOGLE_CLOUD_API_KEY'] ?? '';
  Future<bool> startRecording() async {
    await Permission.microphone.request();
    if (await Permission.microphone.isDenied) {
      return false;
    }
    final dir = await getTemporaryDirectory();
    _filePath = '${dir.path}/speech.flac';

    await _audioRecorder.start(
      RecordConfig(encoder: AudioEncoder.flac, numChannels: 1),
      path: _filePath,
    );
    return true;
  }

  Future<String> stopRecording() async {
    await _audioRecorder.stop();
    return _sendSpeechToText();
  }

  stopRecordingWithoutResult() async {
    await _audioRecorder.stop();
  }

  Future<String> _sendSpeechToText() async {
    if (apiKey.isEmpty) {
      print('API key is invalid.');
      return '';
    }

    final audioFile = File(_filePath);
    final audioContent = base64Encode(audioFile.readAsBytesSync());

    final url = Uri.parse(
      'https://speech.googleapis.com/v1/speech:recognize?key=$apiKey',
    );
    final headers = {'Content-Type': 'application/json'};
    final requestBody = jsonEncode({
      'config': {
        'encoding': 'FLAC',
        'languageCode': 'en-US',
        'model': 'medical_conversation',
      },
      'audio': {'content': audioContent},
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        String result = '';
        if (jsonResponse.containsKey('results')) {
          String previousEndTime = '-1.000';
          jsonResponse['results'].forEach((value) {
            if (value['resultEndTime'] != previousEndTime) {
              result += '${value['alternatives'][0]['transcript']}\n';
            }
            previousEndTime = value['resultEndTime'];
          });
          return result;
        } else {
          return '';
        }
      } else {
        print(response.statusCode);
        print(response.body);
        return '';
      }
    } catch (e) {
      print(e);
      return '';
    }
  }
}
