import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  // 1. Initialize Controller and State variables
  final TextEditingController _controller = TextEditingController();
  late final GenerativeModel _model;
  String _aiResponse = "Type a prompt below and tap send!";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 2. Setup your Gemini Model (Replace with your actual API key)
    // Safely reads key injected via --dart-define-from-file
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');

    _model = GenerativeModel(
      model: 'gemini-3.6-flash', // Uses the fast, efficient model
      apiKey: apiKey,
    );
  }

  // 3. Create the function to call the API
  Future<void> _sendPrompt() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _aiResponse = "Gemini is thinking...";
    });

    final prompt = _controller.text;
    _controller.clear();

    try {
      // Package wraps your text into a Content object and calls Google's servers
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      setState(() {
        _aiResponse = response.text ?? "No response received.";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _aiResponse = "Error occurred: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat With Gemini'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Display Area for the AI's answer
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _aiResponse,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Input Area for the user
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Ask Gemini something...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Send Button
                  IconButton(
                    onPressed: _isLoading ? null : _sendPrompt,
                    icon: _isLoading
                        ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2)
                    )
                        : const Icon(Icons.send),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
