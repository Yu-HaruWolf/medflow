import 'package:firebase_vertexai/firebase_vertexai.dart';

final fetchNursingTool = FunctionDeclaration(
  'fetchNursing',
  'jsonからNANDA-I,goal,観察項目,援助,指導を取得する関数',
  parameters: {
    'nursingJson': Schema.object(
      description: 'SOAPノートの各セクション（NANDA-I,goal,観察項目,援助,指導）を含むJSONオブジェクト。',
      properties: {
        'nanda_i': Schema.string(description: '看護診断の名前'),
        'goal': Schema.string(description: '患者が達成するべき目標'),
        'kansatu': Schema.string(description: '患者の状態を観察するポイント'),
        'ennjo': Schema.string(description: '患者に提供する具体的な援助内容'),
        'sidou': Schema.string(description: '患者や家族に対する教育・指導内容'),
      },
    ),
  },
);

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
