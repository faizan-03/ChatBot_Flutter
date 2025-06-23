import 'package:chat_bot/models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageHelper {
  static const String _key = 'chat_history';
  static Future<void> saveChatHistory(List<Message> messages) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(
      messages.map((msg) => msg.toJson()).toList(),
    );
    await prefs.setString(_key, jsonString);
  }

  static Future<List<Message>> loadChatHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);
    if (jsonString == null) {
      return [];
    }
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Message.fromJson(json)).toList();
  }

  static Future<void> clearChatHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
