import 'dart:core';
import 'package:firebase_vertexai/firebase_vertexai.dart';

class GeminiSearch {
  static Tool tool = Tool(
    functionDeclarations: [
      FunctionDeclaration(
        name: 'Google Search',
        description: 'Perform a Google search and return the results.',
        parameters: JsonSchema(
          type: SchemaType.object,
          properties: {
            'queries': JsonSchema(
              type: SchemaType.array,
              items: JsonSchema(type: SchemaType.string),
              description: 'The list of search queries.',
            ),
          },
          required: ['queries'],
        ),
      ),
    ],
  );
}
