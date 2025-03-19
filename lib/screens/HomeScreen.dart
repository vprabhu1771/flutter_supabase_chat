import 'package:flutter/material.dart';
import 'package:flutter_supabase_chat/widgets/CustomDrawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'ChatDetailScreen.dart';
import 'NewChatScreen.dart';


class HomeScreen extends StatefulWidget {

  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _conversations = [];

  @override
  void initState() {
    super.initState();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    try {
      final response = await supabase.from('conversations').select();
      setState(() {
        _conversations = response;
      });
    } catch (error) {
      print("Error fetching conversations: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: CustomDrawer(parentContext: context),
      body: _conversations.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _conversations.length,
        itemBuilder: (context, index) {
          final conversation = _conversations[index];
          return ListTile(
            title: Text(conversation['name'] ?? 'Unnamed Chat'),
            subtitle:
            Text(conversation['is_group'] ? 'Group Chat' : 'Private Chat'),
            onTap: () {
              // Handle chat navigation
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(
                    conversationId: conversation["id"],
                    receiverEmail: "receiverEmail",
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewChatScreen(title: 'New Chat')),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}