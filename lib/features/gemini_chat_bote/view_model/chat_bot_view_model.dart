import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
// FIXED: Replace 'persistent_chatbot.dart' with your absolute project package structure path
import 'package:mvvm_consepts/features/gemini_chat_bote/repository/chat_bot_repository.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class ChatViewModel extends ChangeNotifier {
  // Ensure your API key is configured safely
  final PersistentChatBot _bot = PersistentChatBot(String.fromEnvironment('GEMINI_API_KEY'));
  final List<ChatMessage> _messages = [];
  bool _isLoading = true;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  ChatViewModel() {
    _init();
  }

  Future<void> _init() async {
    await _bot.initSession();

    // FIXED: Call getChatHistory() which now safely extracts the corrected session parameters
    final history = _bot.getChatHistory();
    for (var content in history) {
      final text = content.parts.map((p) => p is TextPart ? p.text : '').join(' ');
      if (text.isNotEmpty) {
        _messages.add(ChatMessage(text: text, isUser: content.role == 'user'));
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> handleSendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _messages.add(ChatMessage(text: text, isUser: true));
    notifyListeners();

    final response = await _bot.sendMessage(text);
    if (response != null) {
      _messages.add(ChatMessage(text: response, isUser: false));
    }
    notifyListeners();
  }

  // Add this method inside your ChatViewModel class
  Future<void> clearChat() async {
    // 1. Wipe the local JSON file via repository logic
    await _bot.clearAllHistory();

    // 2. Clear the local message array handling the UI display
    _messages.clear();

    // 3. Notify the Provider consumers to refresh the layout
    notifyListeners();
  }

}
