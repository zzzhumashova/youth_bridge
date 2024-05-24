import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String chatName;

  ChatPage({required this.chatName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              // Add message widgets here
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Add send message logic here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
