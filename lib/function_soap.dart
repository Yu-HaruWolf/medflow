import 'package:firebase_vertexai/firebase_vertexai.dart';

final fetchSOAPTool = FunctionDeclaration(
  'fetchSOAP',
  'jsonからSubjective, Objective, Assessment, Planを取得する関数',
  parameters: {
    'soapJson': Schema.object(
      description:
          'SOAPノートの各セクション（Subjective, Objective, Assessment, Plan）を含むJSONオブジェクト。',
      properties: {
        'subjective': Schema.string(description: '患者の主観的情報（例: 痛みの状態など）'),
        'objective': Schema.string(description: '客観的情報（例: 身体的な観察結果、バイタルサインなど）'),
        'assessment': Schema.string(description: '看護師や医師の評価（例: 診断、問題の分析など）'),
        'plan': Schema.string(description: '治療計画や今後のステップ（例: 薬の処方、リハビリ計画など）'),
      },
    ),
  },
);
