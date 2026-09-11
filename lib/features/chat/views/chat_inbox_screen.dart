import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../view_models/chat_inbox_view_model.dart';

class ChatInboxScreen extends StatelessWidget {
  const ChatInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatInboxViewModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF075E54), // Classic WhatsApp Green
          title: const Text("Chats", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
            IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
          ],
        ),
        body: Consumer<ChatInboxViewModel>(
          builder: (context, viewModel, child) {
            return StreamBuilder<List<Map<String, dynamic>>>(
              stream: viewModel.chatRoomsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF075E54)));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No conversations yet. Start chatting!"));
                }

                final rooms = snapshot.data!;
                return ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    // Pick the participant name that isn't the logged-in user
                    final String displayTitle = room['room_name'] ?? "Chat Partner";
                    final String lastMessage = room['last_message'] ?? "Tap to chat...";

                    // Inside your ChatInboxScreen ListView itemBuilder block:
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFF075E54),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(displayTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                      onTap: () {
                        // Navigates cleanly into the messaging bubble view screen
                        context.pushNamed(
                          'chat_room',
                          pathParameters: {
                            'chatRoomId': room['chatRoomId'],
                            'peerUsername': displayTitle,
                          },
                        );
                      },
                    );

                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
