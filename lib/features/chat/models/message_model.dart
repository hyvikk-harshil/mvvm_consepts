class MessageModel {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  int isRead; // 0 = false, 1 = true

  MessageModel({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.isRead = 0,
  });

  // SQL standard mapping utility conversions
  Map<String, dynamic> toLocalMap() {
    return {
      'id': id,
      'chat_room_id': chatRoomId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
    };
  }

  factory MessageModel.fromLocalMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      chatRoomId: map['chat_room_id'],
      senderId: map['sender_id'],
      receiverId: map['receiver_id'],
      text: map['text'],
      timestamp: DateTime.parse(map['timestamp']),
      isRead: map['is_read'] ?? 0,
    );
  }

  // Firebase Remote Firestore mapping utility conversions
  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp.toIso8601String(), // Or use FieldValue.serverTimestamp()
    };
  }

  factory MessageModel.fromFirestoreMap(Map<String, dynamic> map, String docId) {
    return MessageModel(
      id: docId,
      chatRoomId: map['chatRoomId'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      isRead: 1, // Incoming live remote sync strings count as recognized data layers
    );
  }
}
