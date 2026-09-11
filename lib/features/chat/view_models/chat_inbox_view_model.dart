import 'package:flutter/material.dart';
import '../repository/chat_repository.dart';

class ChatInboxViewModel extends ChangeNotifier {
  final ChatRepository _chatRepository = ChatRepository();
  final String currentUserId = "USER-01"; // Replace with your active session user ID

  Stream<List<Map<String, dynamic>>> get chatRoomsStream =>
      _chatRepository.getActiveChatRooms(currentUserId);
}
