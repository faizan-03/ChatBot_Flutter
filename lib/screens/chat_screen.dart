import 'package:chat_bot/utils/storage_helper.dart';
import 'package:chat_bot/widgets/chat_bubble.dart';
import 'package:chat_bot/widgets/input.dart';
import 'package:flutter/material.dart';
import '../models/message.dart';
import '../services/gimini_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final GiminiService _gemini = GiminiService();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final saved = await StorageHelper.loadChatHistory();
    setState(() {
      _messages.addAll(saved);
    });
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final userMessage = Message(
      text: text,
      sender: 'user',
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _controller.clear();
    });

    final botReply = await _gemini.getGiminiResponse(text);

    final botMessage = Message(
      text: botReply,
      sender: 'bot',
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(botMessage);
    });

    await StorageHelper.saveChatHistory(_messages);
  }

  void _clearChat() async {
    await StorageHelper.clearChatHistory();
    setState(() => _messages.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: const Text(
          "Query Assist",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Tooltip(
            message: "Clear chat",
            child: IconButton(
              onPressed: _clearChat,
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder:
                  (context, index) => ChatBubble(message: _messages[index]),
            ),
          ),
          InputField(controller: _controller, onSend: _sendMessage),
        ],
      ),
    );
  }
}
