import 'dart:convert';

import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:http/http.dart' as http;
import 'package:solution_challenge_tcu_2025/data/nursing_plan.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/soap.dart';

import 'gemini_tools.dart';

class GeminiService {
  late GenerativeModel nandaiModel;
  late GenerativeModel soapModel;
  late GenerativeModel nursingPlanModel;
  late GenerativeModel askingModel;

  void geminiInit() {
    // Set parameter values in a `GenerationConfig` (example values shown here)
    final generationConfig = GenerationConfig(temperature: 0.0);
    nandaiModel = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-2.0-flash',
      generationConfig: generationConfig,
      systemInstruction: Content.text("""
You are an excellent nurse. 
determine the single NANDA-I diagnosis that should be given the highest priority at this time.
"""),
    );

    soapModel = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-2.0-flash',
      tools: [
        Tool.functionDeclarations([fetchSOAPTool]),
      ],
      systemInstruction: Content.text("""
This is the content of a conversation between a nurse and a patient.\n
Referring to the content of this conversation and the patient's nursing care plan, please output Subjective (subjective information), Objective (objective information), Assessment (evaluation), and Plan (plan) in JSON format, which is one method of documenting nursing records.\n
For the Plan, please infer whether to use the current NANDA-I items or transition to the new NANDA-I.\n\n
1. Search Google for how to write SOAP in nursing care plans.\n
2. Extract the important parts in SOAP from the nursing care plan and the conversation content.\n
3. Perform a Google Search on how SOAP is written and what points to consider in the current NANDA-I of the nursing care plan.\n
4. Considering the points to note in SOAP through steps 1, 2, and 3, construct the SOAP by referring to the nursing care plan and the conversation content.\n
5. For the Plan section, only state whether to continue with the current NANDA-I or change to the new NANDA-I.\n
6. Pass the output JSON as an argument to the fetchSOAPtool function for processing.
"""),
    );

    nursingPlanModel = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-2.0-flash',
      systemInstruction: Content.text(
        """You are an excellent nurse. I will now create a discharge nursing care plan.\n
1. Understanding  the most critical NANDA-I diagnosis based on converstation history and how to writing nursing plan based on NANDA-I .\n
2. Create a nursing care plan according to that NANDA-I diagnosis.\n
3. Create the most suitable NANDA-I diagnosis by referring to the patient's information, SOAP content, and nurse's notes, etc.\n\n
Please output the format in JSON format as follows
The detailed output format is shown below:
{
  nanda_i: "STRING",
  goal: "STRING",
  observation: "STRING",
  therapeutic: "STRING",
  educational: "STRING",
}
You must not send anything other than json. Your message only text of json. not markdown.
""",
      ),
    );

    askingModel = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-2.0-flash',
      systemInstruction: Content.text("""
Please provide an appropriate response to the user's question.
"""),
    );
  }

  // GETリクエストを送信する関数
  Future<Map<String, dynamic>?> fetchGoogleSearchData(String prompt) async {
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

  Future<NursingPlan> generateNursingPlan(
    Patient patient,
    NursingPlan nursingplan,
    Soap soap,
    String notes,
  ) async {
    //最終的のsoapに変更する
    // soap = patient.historyOfSoap.last;
    // historyOfSoapが空でない場合のみlastを使う
    if (patient.historyOfSoap.isNotEmpty) {
      soap = patient.historyOfSoap.last;
    }
    // 1. GAEからレスポンスを取得
    String responseText = "";
    final responseFromGoogleSearch = await fetchGoogleSearchData(
      "Please investigate NANDA-I usin Google search. What types of NANDA-I exist, and please tell me all the evaluation criteria for each",
    );

    if (responseFromGoogleSearch != null) {
      responseText =
          responseFromGoogleSearch['response']; // Cloud Functionからのレスポンス
    } else {
      responseText = "Failed to load data";
    }

    // 2. 過去の会話履歴を設定
    final chatHistory = [
      Content.text(
        'Please research NANDA-I. What NANDA-I diagnoses exist, and please tell me all the evaluation criteria for each one?',
      ),
      Content.model([TextPart(responseText)]),
    ];

    // 3. Geminiに問い合わせ
    GenerateContentResponse responseNandai = await nandaiModel
        .startChat(history: chatHistory)
        .sendMessage(
          Content.text("""
Based on the patient's information, understand their current clinical condition. Then, determine the single NANDA-I diagnosis that should be given the highest priority at this time.
When making this determination, consult the nursing care plan, SOAP note content, memos, and refer specifically to NANDA-I items and evaluation criteria from the conversation history to infer the most suitable diagnosis.
patient information:${patient.toJson()}

Please note that if the following information is provided, it may differ significantly from the patient's current clinical condition. Therefore, please refer to it carefully / take it strongly into consideration.
nursing plan :${nursingplan.toJson()}
SOAP:${soap.toJson()}
memo：${notes}
"""),
        );
    String intermediateResponse = "${responseNandai.text}";

    chatHistory.add(
      Content.text('Please determine the optimal NANDA-I diagnosis.'),
    );
    chatHistory.add(Content.model([TextPart(intermediateResponse)]));
    GenerateContentResponse responseNursingPlan = await nursingPlanModel
        .startChat(history: chatHistory)
        .sendMessage(
          Content.text("""
Please identify the NANDA-I items to be prioritized by reviewing the conversation history, and give these items the highest importance.
Create a nursing care plan for these prioritized NANDA-I items using a Google search.

Add patient-specific details (such as the patient's occupation, family structure, etc.) from SOAP notes and the admission database to this plan.
The nursing care plan created should include the following content, and it must be output in JSON format.
{
  nanda_i:  ,
  goal:    ,
  observation:   ,
  therapeutic:  ,
  educational:  ,
}
・O-P Observations / Assessment / Observation Items
・T-P Therapeutic Plan / Interventions / Care Plan
・E-P Educational Plan / Patient Education / Teaching Pla
Patient Information :${patient.toJson()}

Please note that if the following information is provided, it may differ significantly from the patient's current clinical condition. Therefore, please use it as a major reference point.
Nursing Plan:${nursingplan.toJson()}
SOAP:${soap.toJson()}
memo：${notes}
"""),
        );
    String accumulatedText = "${responseNursingPlan.text}";
    final NursingPlan newPlan;
    try {
      // JSON部分を正規表現で抽出
      final regex = RegExp(r'\{[\s\S]*\}');
      final match = regex.firstMatch(accumulatedText);

      if (match != null) {
        final jsonString = match.group(0)!;
        final jsonObject = jsonDecode(jsonString);

        newPlan = NursingPlan(
          nanda_i: jsonObject['nanda_i'] ?? '',
          goal: jsonObject['goal'] ?? '',
          op: jsonObject['observation'] ?? '',
          tp: jsonObject['therapeutic'] ?? '',
          ep: jsonObject['educational'] ?? '',
        );

        return newPlan;
      } else {
        print('JSON error');
      }
    } catch (e) {
      print('JSONerror : $e');
      throw Exception('JSON error : $e');
    }
    // 関数の最後に追加
    throw Exception("creation of nursing plan failed");
    // 実際のPatientオブジェクトを作成して返す
  }

  Future<Soap> generateSoap(
    Patient patient,
    NursingPlan nursingPlan,
    Soap soap,
    String notes,
  ) async {
    // 1. GAEからレスポンスを取得
    String responseGoogleSearchText = "";
    final responseGoogleSearch = await fetchGoogleSearchData(
      "Please tell me the points to be aware of when writing nursing care plans and SOAP notes. What does each section of SOAP entail? Please summarize after conducting a Google search.Points to Consider When Writing Nursing Care Plans?",
    );

    if (responseGoogleSearch != null) {
      responseGoogleSearchText =
          responseGoogleSearch['response']; // Cloud Functionからのレスポンス
    } else {
      responseGoogleSearchText = "Failed to load data";
    }

    final history = [
      Content.text(
        'Please tell me the points to be aware of when writing nursing care plans and SOAP notes. What does each section of SOAP entail? Please summarize after conducting a Google search.Points to Consider When Writing Nursing Care Plans?',
      ),
      Content.model([TextPart(responseGoogleSearchText)]),
    ];
    String json_responseText = "";
    GenerateContentResponse responseSoap = await soapModel
        .startChat(history: history)
        .sendMessage(
          Content.text("""
Based on the conversation history, please provide a SOAP note, considering the items and points to note when writing it.
Create today's SOAP note by referencing the patient information, nursing care plan, and the content of yesterday's SOAP note.
For example, if there was pain or other issues on the previous day, please create today's SOAP note reflecting that.
The information for today's SOAP note is as follows:
${notes}

Patient Informaiton:${patient.toJson()}
Nursing Plan:${nursingPlan.toJson()}
SOAP:${soap.toJson()}
Please extract the SOAP note content and output it in JSON format.
    {
  subject:  ,
  object:    ,
  assessment:   ,
  plan:  ,
}
"""),
        );

    String accumulatedText = "${responseSoap.text}";

    final Soap newSoap;
    try {
      // JSON部分を正規表現で抽出
      final regex = RegExp(r'\{[\s\S]*\}');
      final match = regex.firstMatch(accumulatedText);

      if (match != null) {
        final jsonString = match.group(0)!;
        final jsonObject = jsonDecode(jsonString);

        newSoap = Soap(
          subject: jsonObject['subjective'] ?? '',
          object: jsonObject['objective'] ?? '',
          assessment: jsonObject['assessment'] ?? '',
          plan: jsonObject['plan'] ?? '',
        );

        return newSoap;
      } else {
        print('json error');
      }
    } catch (e) {
      print('JSON error: $e');
      throw Exception("JSON error: $e");
    }
    // When failed to create SOAP
    throw Exception("creation of SOAP failed");
  }

  Future<String> askGemini(
    Patient patient,

    NursingPlan nursingplan,
    Soap soap,
    String prompt,
  ) async {
    // 3. Geminiに問い合わせ
    GenerateContentResponse response = await askingModel
        .startChat()
        .sendMessage(
          Content.text("""
Instead of providing a general answer to the prompt, if it requires referring to the patient's nursing plan, patient, and soap below. please consult the following nursing plan, patient information, and SOAP content. Extract the relevant sections/information from these sources, and generate the response to the prompt based on that extracted information.
The data is below.You have to use the data below to answer the question.
              
patient information:${patient.toJson()}
nursing plan :${nursingplan.toJson()}
SOAP:${soap.toJson()}
  
${prompt}            
"""),
        );

    final responseText = response.text;

    return responseText ?? ''; // responseTextがnullだった場合は''を返す
  }
}
