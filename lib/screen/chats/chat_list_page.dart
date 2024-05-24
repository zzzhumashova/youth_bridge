import 'package:flutter/material.dart';
import 'package:youth_bridge/screen/chats/chat_page.dart';
import 'package:youth_bridge/widgets/themes.dart';

class ChatListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Personal Chat 1'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage(chatName: 'Personal Chat 1')),
              );
            },
          ),
          ListTile(
            title: Text('Forum Chat 1'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage(chatName: 'Forum Chat 1')),
              );
            },
          ),
        ],
      ),
    );
  }
}
