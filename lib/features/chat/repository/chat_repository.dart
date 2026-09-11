import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Stream active chat conversations based on user ID
  Stream<List<Map<String, dynamic>>> getActiveChatRooms(String currentUserId) {
    return _firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        data['chatRoomId'] = doc.id;
        return data;
      }).toList();
    });
  }

  // 2. Push message directly to Cloud Firestore
  Future<void> uploadMessageToFirebase(MessageModel message) async {
    await _firestore
        .collection('chat_rooms')
        .doc(message.chatRoomId)
        .collection('messages')
        .doc(message.id)
        .set(message.toFirestoreMap());
  }

  // 3. Real-time background sync stream channel pipeline looking for Firestore changes
  Stream<List<MessageModel>> getFirebaseMessageStream(String chatRoomId) {
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false) // Ordered oldest to newest for chronological chat order
        .snapshots()
        .map((snapshot) {
      List<MessageModel> messages = [];
      for (var doc in snapshot.docs) {
        messages.add(MessageModel.fromFirestoreMap(doc.data(), doc.id));
      }
      return messages;
    });
  }
}
