import 'package:flutter/material.dart';
import '../models/conversation_preview.dart';
import '../services/chat_service.dart';
import 'chat_screen.dart';

// Reuse mockUserNames map from ConversationsScreen
const Map<String, String> mockUserNames = {
  'user1': 'You',
  'user2': 'Bob',
  'user3': 'Charlie',
  'user4': 'Dave',
  // Add other mock users here
};

class ArchivedChatsScreen extends StatefulWidget {
  const ArchivedChatsScreen({super.key});

  @override
  State<ArchivedChatsScreen> createState() => _ArchivedChatsScreenState();
}

class _ArchivedChatsScreenState extends State<ArchivedChatsScreen> {
  final ChatService _chatService = ChatService();

  Future<void> _unarchiveConversation(String convoId) async {
    try {
      await _chatService.archiveConversation(convoId, archive: false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conversation unarchived')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to unarchive conversation: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived Chats'),
      ),
      body: StreamBuilder<List<ConversationPreview>>(
        stream: _chatService.getConversations(includeArchived: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Filter only archived conversations
          final archivedConvos = snapshot.data
              ?.where((conv) => conv.isArchived == true)
              .toList() ??
              [];

          if (archivedConvos.isEmpty) {
            return const Center(child: Text('No archived chats found.'));
          }

          return ListView.builder(
            itemCount: archivedConvos.length,
            itemBuilder: (context, index) {
              final convo = archivedConvos[index];
              final chatPartnerId = convo.participants.firstWhere(
                      (id) => id != _chatService.currentUserId,
                  orElse: () => 'Unknown');

              final chatPartnerName =
                  mockUserNames[chatPartnerId] ?? chatPartnerId;

              return ListTile(
                title: Text('Chat with $chatPartnerName'),
                subtitle: Text(convo.lastMessage),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        conversationId: convo.id,
                        isArchived: true,  // Archived chat
                      ),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.unarchive),
                  tooltip: 'Unarchive',
                  onPressed: () => _unarchiveConversation(convo.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
