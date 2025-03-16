  import 'dart:async';

  import 'package:flutter/material.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';
  import 'package:chat_bubbles/chat_bubbles.dart';

  class ChatDetailScreen extends StatefulWidget {
    final String receiverId;
    final String receiverEmail;

    const ChatDetailScreen({super.key, required this.receiverId, required this.receiverEmail});

    @override
    State<ChatDetailScreen> createState() => _ChatDetailScreenState();
  }

  class _ChatDetailScreenState extends State<ChatDetailScreen> {
    final SupabaseClient supabase = Supabase.instance.client;
    final TextEditingController _messageController = TextEditingController();
    final ScrollController _scrollController = ScrollController(); // Scroll controller

    late String userId; // Store the current logged-in user's ID

    StreamSubscription? _messageSubscription; // Store subscription

    @override
    void initState() {
      super.initState();
      userId = supabase.auth.currentUser!.id; // Get the logged-in user's ID
      _listenForNewMessages();
      // _fetchMessages();
    }

    // Fetch messages from Supabase
    Future<List<Map<String, dynamic>>> _fetchMessages() async {
      final response = await supabase
          .from('messages')
          .select('id, sender_id, receiver_id, message, created_at')
          .or('sender_id.eq.${userId},receiver_id.eq.${userId}') // Fetch only relevant messages
          .order('created_at', ascending: true); // Ensure messages are in correct order

      return response;
    }

    // Send a new message
    Future<void> _sendMessage() async {
      if (_messageController.text.trim().isEmpty) return; // Prevent empty messages

      try {
        await supabase.from('messages').insert({
          'receiver_id': widget.receiverId,
          'sender_id': userId,
          'message': _messageController.text.trim(),
          'created_at': DateTime.now().toIso8601String(),
        });

        _messageController.clear();
        setState(() {});

        // Scroll to the latest message after a short delay
        Future.delayed(const Duration(milliseconds: 300), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      } catch (e) {
        print('Exception while sending message: $e');
      }
    }

    // Listen for new messages in real-time
    void _listenForNewMessages() {
      _messageSubscription = supabase
          .from('messages')
          .stream(primaryKey: ['id'])
          .order('created_at', ascending: true) // Ensure messages are in correct order
          .listen((messages) {
        if (!mounted) return; // Check if the widget is still in the tree
        setState(() {});

        // Scroll to the latest message after a short delay
        Future.delayed(const Duration(milliseconds: 300), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      });
    }

    // Dispose the stream when the widget is removed
    @override
    void dispose() {
      _messageSubscription?.cancel(); // Cancel the subscription to avoid memory leaks
      _messageController.dispose(); // Dispose of the text controller
      _scrollController.dispose(); // Dispose of the scroll controller
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.receiverEmail)), // Show receiver's email in AppBar
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchMessages(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!;

                  return ListView.builder(
                    controller: _scrollController, // Attach scroll controller
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final bool isMe = msg['sender_id'] == userId;

                      return CustomChatBubble(
                        message: msg['message'],
                        isSentByMe: isMe,
                      );
                    },
                  );
                },
              ),
            ),
            MessageBar(
              onSend: (text) async {
                if (text.trim().isEmpty) return; // Prevent sending empty messages
                _messageController.text = text; // Assign text to controller
                await _sendMessage(); // Send the message
              },
              actions: [
                InkWell(
                  child: const Icon(Icons.add, color: Colors.black, size: 24),
                  onTap: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: InkWell(
                    child: const Icon(Icons.camera_alt, color: Colors.green, size: 24),
                    onTap: () {},
                  ),
                ),
              ],
            ),


          ],
        ),
      );
    }
  }

  // Chat Bubble Widget
  class CustomChatBubble extends StatelessWidget {
    final String message;
    final bool isSentByMe; // True if the message is from the current user

    const CustomChatBubble({
      super.key,
      required this.message,
      required this.isSentByMe,
    });

    @override
    Widget build(BuildContext context) {
      return Align(
        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: BubbleSpecialThree(
          text: message,
          color: isSentByMe ? Colors.blue : Colors.grey[300]!,
          tail: true,
          textStyle: TextStyle(
            color: isSentByMe ? Colors.white : Colors.black,
            fontSize: 16,
          ),
          isSender: isSentByMe,
        ),
      );
    }
  }