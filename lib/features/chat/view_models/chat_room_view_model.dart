import 'dart:async';
import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../repository/chat_repository.dart';

class ChatRoomViewModel extends ChangeNotifier {
  final ChatRepository _chatRepository;
  final String chatRoomId;

  List<MessageModel> _messages = [];
  bool _isLoading = true;
  StreamSubscription? _firebaseSubscription;

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  ChatRoomViewModel({required ChatRepository repository, required this.chatRoomId})
      : _chatRepository = repository {
    _initChatFlow();
  }

  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;

  // Open live stream connection directly to Cloud Firestore
  void _initChatFlow() {
    _firebaseSubscription = _chatRepository.getFirebaseMessageStream(chatRoomId).listen((remoteMessages) {
      _messages = remoteMessages;
      _isLoading = false;
      notifyListeners();
      _scrollToBottom();
    });
  }

  // Handle outgoing messages to Firebase
  Future<void> sendMessage({required String senderId, required String receiverId}) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatRoomId: chatRoomId,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      timestamp: DateTime.now(),
    );

    messageController.clear();

    // Upload straight to cloud backend infrastructure
    await _chatRepository.uploadMessageToFirebase(newMessage);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _firebaseSubscription?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
