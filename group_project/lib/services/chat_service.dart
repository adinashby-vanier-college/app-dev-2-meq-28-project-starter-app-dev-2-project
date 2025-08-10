import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/conversation_preview.dart';
import '../models/message.dart';
import '../mock/mock_user.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String currentUserId = mockCurrentUserId;

  // Send a message using the existing conversation ID
  Future<void> sendMessage(String conversationId, String text) async {
    final convoRef = _firestore.collection('conversations').doc(conversationId);
    final messagesRef = convoRef.collection('messages').doc();

    final now = DateTime.now();

    // Parse participants from conversationId (e.g. 'user1_user2')
    final participants = conversationId.split('_');
    if (!participants.contains(currentUserId)) {
      throw Exception('Current user is not part of this conversation');
    }
    // Identify the chat partner ID (the other user)
    final chatPartnerId = participants.firstWhere((id) => id != currentUserId);

    await _firestore.runTransaction((transaction) async {
      // Add the new message
      transaction.set(messagesRef, {
        'senderId': currentUserId,
        'receiverId': chatPartnerId,
        'text': text,
        'timestamp': now,
        'isRead': false,
      });

      // Update or create the conversation document
      transaction.set(convoRef, {
        'participants': participants,
        'lastMessage': text,
        'lastMessageTime': now,
        'unreadCounts': {
          chatPartnerId: FieldValue.increment(1), // increment unread count for receiver
          currentUserId: 0,                       // reset unread count for sender
        },
        'status': {
          currentUserId: 'active',
          chatPartnerId: 'active',
        },
      }, SetOptions(merge: true));
    });
  }

  Stream<List<ConversationPreview>> getConversations({bool includeArchived = false}) {
    Query q = _firestore
        .collection('conversations')
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true);

    if (!includeArchived) {
      q = q.where('archived', isEqualTo: false);
    }

    return q.snapshots().map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>?;

      if (data == null) return null;

      final unreadCountsMap = data['unreadCounts'] as Map<String, dynamic>?;
      final statusMap = data['status'] as Map<String, dynamic>?;

      return ConversationPreview(
        id: doc.id,
        lastMessage: data['lastMessage'] ?? '',
        lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
        participants: List<String>.from(data['participants'] ?? []),
        unreadCount: unreadCountsMap?[currentUserId] as int? ?? 0,
        status: statusMap?[currentUserId] as String? ?? 'active',
        isArchived: data['archived'] as bool? ?? false,  // <- This is key
      );
    }).where((conv) => conv != null).cast<ConversationPreview>().toList());

  }

  Stream<List<Message>> getMessages(String conversationId) {
    final messagesRef = _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false);

    return messagesRef.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Message.fromMap(doc.data(), doc.id, conversationId))
        .toList());
  }

  Future<void> markMessagesRead(String conversationId) async {
    final convoRef = _firestore.collection('conversations').doc(conversationId);

    await convoRef.set({
      'unreadCounts': {currentUserId: 0}
    }, SetOptions(merge: true));
  }

  Future<void> deleteMessage(String conversationId, String messageId) async {
    final messageRef = _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc(messageId);

    await messageRef.delete();
  }

  Future<void> deleteConversation(String convoId) async {
    final convoRef = _firestore.collection('conversations').doc(convoId);
    final messagesSnapshot = await convoRef.collection('messages').get();

    final batch = _firestore.batch();
    for (var doc in messagesSnapshot.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(convoRef);

    await batch.commit();
  }

  Future<void> archiveConversation(String convoId, {bool archive = true}) async {
    final convoRef = _firestore.collection('conversations').doc(convoId);
    await convoRef.set({'archived': archive}, SetOptions(merge: true));
  }
}