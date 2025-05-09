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
