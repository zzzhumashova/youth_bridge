import 'package:flutter/material.dart';
import 'package:youth_bridge/screen/chats/chat_page.dart';

class PersonalChat extends StatelessWidget {
  final List<Map<String, dynamic>> chats = [
    {'avatarUrl': 'https://via.placeholder.com/150', 'name': 'Alice', 'lastMessage': 'How are you?', 'time': '10:30 AM'},
    {'avatarUrl': 'https://via.placeholder.com/150', 'name': 'Bob', 'lastMessage': 'Вы: Let\'s meet tomorrow', 'time': 'Yesterday'},
    {'avatarUrl': 'https://via.placeholder.com/150', 'name': 'Charlie', 'lastMessage': 'See you!', 'time': 'Yesterday'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        var chat = chats[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(chat['avatarUrl']),
            child: Text(chat['name'].substring(0, 1)),
          ),
          title: Text(chat['name']),
          subtitle: Text(chat['lastMessage']),
          trailing: Text(chat['time']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(chatTitle: chat['name'], avatarUrl: chat['avatarUrl'],),
              ),
            );
          },
        );
      },
    );
  }
}
