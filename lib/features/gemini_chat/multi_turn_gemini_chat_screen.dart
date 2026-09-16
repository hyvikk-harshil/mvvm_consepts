import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// 1. Create a data model to hold individual chat messages in the UI
class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class MultiTurnChatScreen extends StatefulWidget {
  const MultiTurnChatScreen({super.key});
  @override
  State<MultiTurnChatScreen> createState() => _MultiTurnChatScreenState();
}
class _MultiTurnChatScreenState extends State<MultiTurnChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // 2. Define the GenerativeModel and the ChatSession
  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  // List to display the messages sequentially on screen
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize the Gemini model
    // Safely reads key injected via --dart-define-from-file
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    _model = GenerativeModel(
      model: 'gemini-3.6-flash', // Uses the fast, efficient model
      apiKey: apiKey,
    );

    // 3. Start a multi-turn chat session. This automatically stores conversation history.
    _chatSession = _model.startChat();
  }

  // 4. Handle sending messages through the chat session
  Future<void> _sendMessage() async {
    final userText = _controller.text.trim();
    if (userText.isEmpty) return;

    _controller.clear();

    // Add user's message to the UI list immediately
    setState(() {
      _messages.add(ChatMessage(text: userText, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      // 5. Send message using the chat session instead of generateContent
      final response = await _chatSession.sendMessage(Content.text(userText));

      setState(() {
        _messages.add(ChatMessage(text: response.text ?? 'No reply context.', isUser: false));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(text: 'Error occurred: $e', isUser: false));
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Smart Chat'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 6. The scrollable Chat Feed
            Expanded(
              child: _messages.isEmpty
                  ? const Center(child: Text('Say hello to Gemini! It will remember this conversation.'))
                  : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: message.isUser
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(16).copyWith(
                          bottomRight: message.isUser ? const Radius.circular(0) : const Radius.circular(16),
                          topLeft: message.isUser ? const Radius.circular(16) : const Radius.circular(0),
                        ),
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: message.isUser ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),

            // 7. Text Input Field and Action Button
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: (_) => _isLoading ? null : _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    icon: const Icon(Icons.send),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
