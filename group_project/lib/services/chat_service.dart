import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';
import '../mock/mock_user.dart'; // contains mockCurrentUserId

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Use the shared mock user ID (can be replaced later with Firebase Auth)
  final String currentUserId = mockCurrentUserId;

  Stream<List<Message>> getMessages(String chatPartnerId) {
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Message.fromMap(doc.data(), doc.id))
        .where((msg) =>
    (msg.senderId == currentUserId &&
        msg.receiverId == chatPartnerId) ||
        (msg.senderId == chatPartnerId &&
            msg.receiverId == currentUserId))
        .toList());
  }

  Future<void> sendMessage(String chatPartnerId, String text) async {
    final message = Message(
      id: '', // Firestore will assign one
      senderId: currentUserId,
      receiverId: chatPartnerId,
      text: text,
      timestamp: DateTime.now(),
    );

    await _firestore.collection('messages').add(message.toMap());
  }
}
