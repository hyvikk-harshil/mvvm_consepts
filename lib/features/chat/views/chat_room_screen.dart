import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repository/chat_repository.dart';
import '../view_models/chat_room_view_model.dart';

class ChatRoomScreen extends StatelessWidget {
  final String chatRoomId;
  final String peerUsername;
  final String currentUserId = "USER-01";
  final String peerId = "USER-02";

  const ChatRoomScreen({
    super.key,
    required this.chatRoomId,
    required this.peerUsername,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Clear initialization directly mapping onto your clean Cloud repository layer
      create: (_) => ChatRoomViewModel(
        chatRoomId: chatRoomId,
        repository: ChatRepository(),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF075E54),
          title: Text(peerUsername, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: Container(
            color: const Color(0xFFECE5DD),
            child: Column(
              children: [
                // MESSAGE TIMELINE AREA
                Expanded(
                  child: Consumer<ChatRoomViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.isLoading) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFF075E54)));
                      }
                      return ListView.builder(
                        controller: viewModel.scrollController,
                        padding: const EdgeInsets.all(12),
                        itemCount: viewModel.messages.length,
                        itemBuilder: (context, index) {
                          final message = viewModel.messages[index];
                          final bool isMe = message.senderId == currentUserId;

                          return Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isMe ? const Color(0xFFDCF8C6) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  )
                                ],
                              ),
                              child: Text(
                                message.text,
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // INPUT BAR PANEL
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                          child: Consumer<ChatRoomViewModel>(
                            builder: (context, viewModel, child) {
                              return TextField(
                                controller: viewModel.messageController,
                                decoration: const InputDecoration(
                                  hintText: "Type a message",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                  border: InputBorder.none,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Consumer<ChatRoomViewModel>(
                        builder: (context, viewModel, child) {
                          return CircleAvatar(
                            backgroundColor: const Color(0xFF075E54),
                            radius: 24,
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.white),
                              onPressed: () => viewModel.sendMessage(
                                senderId: currentUserId,
                                receiverId: peerId,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
