import 'package:flutter/material.dart';
import '../models/message.dart';

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUser)
              CircleAvatar(
                backgroundImage: AssetImage('assets/avatar-bot.jpg'),
                radius: 18,
              ),
            if (!isUser) const SizedBox(width: 6),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUser ? Colors.blueAccent : Colors.grey[300],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(color: isUser ? Colors.white : Colors.black),
                ),
              ),
            ),
            if (isUser) const SizedBox(width: 6),
            if (isUser)
              CircleAvatar(
                backgroundImage: AssetImage('assets/avatar-user.jpg'),
                radius: 18,
              ),
          ],
        ),
      ),
    );
  }
}
