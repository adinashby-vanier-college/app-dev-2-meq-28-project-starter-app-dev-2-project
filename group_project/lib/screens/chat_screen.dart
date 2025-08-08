import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';
import '../utils/loading_spinner.dart';
import '../mock/mock_user.dart';
import '../models/message.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  bool _canSend = false;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final textNotEmpty = _controller.text.trim().isNotEmpty;
      if (textNotEmpty != _canSend) {
        setState(() => _canSend = textNotEmpty);
      }
    });

    // Simulate loading or any initial setup
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _controller.clear();
      _canSend = false;
    });

    try {
      await _chatService.sendMessage(mockChatPartnerId, text);
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0, // because reverse = true
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SkillSwap Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.vertical_align_top),
            tooltip: 'Scroll to top',
            onPressed: _scrollToTop,
          ),
          IconButton(
            icon: const Icon(Icons.vertical_align_bottom),
            tooltip: 'Scroll to bottom',
            onPressed: _scrollToBottom,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingSpinner()
          : Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatService.getMessages(mockChatPartnerId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingSpinner();
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading messages: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!;

                // Auto-scroll on new message
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (ctx, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == mockCurrentUserId;
                    return ChatBubble(
                      key: ValueKey(msg.id),
                      message: msg.text,
                      isMe: isMe,
                      timestamp: msg.timestamp, // Pass timestamp here
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Type a message...',
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: _canSend ? Theme.of(context).primaryColor : Colors.grey,
                  onPressed: _canSend ? _sendMessage : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
