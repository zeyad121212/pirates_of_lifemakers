import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ChatSelectorScreen extends StatelessWidget {
  const ChatSelectorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example static chat list. Replace with dynamic data from Firebase as needed.
    final chats = [
      {'id': 'public', 'title': 'Public Group'},
      {'id': 'dv_cc', 'title': 'DV ↔ CC'},
      {'id': 'sv_tr', 'title': 'SV ↔ TR'},
      {'id': 'cc_mb_dvs', 'title': 'CC + MB + DVs'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, i) {
          final chat = chats[i];
          return ListTile(
            title: Text(chat['title']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(chatId: chat['id']!, chatTitle: chat['title']!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
