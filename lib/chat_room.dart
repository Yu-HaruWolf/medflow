import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as chat_core;
import 'dart:math';

void main() {
  runApp(ChatRoomPage());
}

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late final chat_core.InMemoryChatController _chatController;
  final String _currentUserId = 'user1';
  final Map<String, chat_core.User> _userMap = {
    'user1': const chat_core.User(id: 'user1', name: 'User'),
    'user2': const chat_core.User(id: 'user2', name: 'Bot'),
  };

  @override
  void initState() {
    super.initState();
    _chatController = chat_core.InMemoryChatController(
      messages: [
        chat_core.Message.text(
          id: 'msg1',
          authorId: 'user1',
          createdAt: DateTime.now(),
          text: 'こんにちは！',
        ),
        chat_core.Message.text(
          id: 'msg2',
          authorId: 'user2',
          createdAt: DateTime.now(),
          text: 'こんにちは、どうされましたか？',
        ),
      ],
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  Future<chat_core.User> _resolveUser(String userId) async {
    return _userMap[userId]!;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ChatScreen')),
        body: Chat(
          chatController: _chatController,
          currentUserId: _currentUserId,
          onMessageSend: (text) {
            _chatController.insertMessage(
              chat_core.Message.text(
                id: '${Random().nextInt(1000000)}',
                authorId: _currentUserId,
                createdAt: DateTime.now(),
                text: text,
              ),
            );
          },
          resolveUser: _resolveUser,
        ),
      ),
    );
  }
}
