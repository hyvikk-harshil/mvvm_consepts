import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PersistentChatBot {
  late final GenerativeModel _model;
  ChatSession? _chatSession;
  static const String _fileName = 'chat_history_cache.json';

  PersistentChatBot(String apiKey) {
    _model = GenerativeModel(
      model: 'gemini-3.6-flash',
      apiKey: apiKey,
      systemInstruction: Content.system("You are an intelligent assistant."),
    );
  }

  Future<File> _getLocalFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File(p.join(directory.path, _fileName));
  }

  Future<void> initSession() async {
    try {
      final file = await _getLocalFile();
      List<Content> historicalMessages = [];

      if (await file.exists()) {
        final List<dynamic> decodedList = jsonDecode(await file.readAsString());
        historicalMessages = decodedList.map((item) {
          final String role = item['role'];
          final String text = item['text'];
          return role == 'user' ? Content.text(text) : Content.model([TextPart(text)]);
        }).toList();
      }
      _chatSession = _model.startChat(history: historicalMessages);
    } catch (e) {
      _chatSession = _model.startChat();
    }
  }

  // FIXED: Changed from getHistory() method to a clean history property mapping
  List<Content> getChatHistory() {
    if (_chatSession == null) return [];
    return _chatSession!.history.toList(); // Using the correct '.history' property
  }
  // Add this method inside the PersistentChatBot class
  Future<void> clearAllHistory() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      await file.delete(); // Removes the file from device storage
    }
    // Reset the active session with a clean slate
    _chatSession = _model.startChat();
  }


  Future<String?> sendMessage(String message) async {
    if (_chatSession == null) return null;
    try {
      final response = await _chatSession!.sendMessage(Content.text(message));
      await _saveHistoryToDisk();
      return response.text;
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<void> _saveHistoryToDisk() async {
    if (_chatSession == null) return;
    final file = await _getLocalFile();

    // FIXED: Changed .getHistory() to .history
    final List<Content> currentHistory = _chatSession!.history.toList();

    final List<Map<String, String>> serializableHistory = currentHistory.map((content) {
      return {
        'role': content.role ?? 'user',
        'text': content.parts.map((part) => part is TextPart ? part.text : '').join(' '),
      };
    }).toList();

    await file.writeAsString(jsonEncode(serializableHistory));
  }
}
