import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

final List<types.Message> sampleMessages = [
  types.TextMessage(
    author: const types.User(id: 'user1', firstName: 'User'),
    createdAt: DateTime.now().millisecondsSinceEpoch,
    id: 'msg1',
    text: 'こんにちは！',
  ),
  types.TextMessage(
    author: const types.User(id: 'user2', firstName: 'Bot'),
    createdAt: DateTime.now().millisecondsSinceEpoch,
    id: 'msg2',
    text: 'こんにちは、どうされましたか？',
  ),
];
