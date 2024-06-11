import 'package:flutter/material.dart';
import 'package:youth_bridge/screen/chats/chat_page.dart';

class ForumChat extends StatefulWidget {
  @override
  _ForumChatState createState() => _ForumChatState();
}

class _ForumChatState extends State<ForumChat> {
  late List<Map<String, dynamic>> forumChats;
  Map<String, dynamic>? selectedChat;

  @override
  void initState() {
    super.initState();
    forumChats = [
      {
        "avatarUrl": "https://via.placeholder.com/150",
        "organizationName": "Организация 1",
        "lastMessage": "Админ: Как пройдет событие завтра?",
        "time": "15:30",
        "subChats": [
          {"name": "Вопросы", "lastMessage": "Вы: Можно ли прийти с друзьями?"},
          {"name": "Общение", "lastMessage": "Юлия: Да, конечно!"},
        ]
      },
      {
        "avatarUrl": "https://via.placeholder.com/150",
        "organizationName": "Организация 2",
        "lastMessage": "Максим: Не забудьте материалы!",
        "time": "Вчера",
        "subChats": [
          {"name": "Вопросы", "lastMessage": "Анна: Сколько это стоит?"},
          {"name": "Название Ивента", "lastMessage": "Марк: Увидимся там!"},
        ]
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: selectedChat == null,
          child: ListView.builder(
            itemCount: forumChats.length,
            itemBuilder: (context, index) {
              var chat = forumChats[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(chat['avatarUrl']),
                  child: Text(chat['organizationName'].substring(0, 1)),
                ),
                title: Text(chat["organizationName"]),
                subtitle: Text(chat["lastMessage"]),
                trailing: Text(chat["time"]),
                onTap: () {
                  setState(() {
                    selectedChat = chat;
                  });
                },
              );
            },
          ),
        ),
        // Sub-chat list
        Visibility(
          visible: selectedChat != null,
          child: Column(
            children: [
              AppBar(
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage("https://via.placeholder.com/150"),
                      child: Text(selectedChat?['name']?.substring(0, 1) ?? ''),
                    ),
                    SizedBox(width: 15,),
                    Text(selectedChat?["organizationName"] ?? ""),
                  ],
                ),
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 25,),
                  onPressed: () {
                    setState(() {
                      selectedChat = null;
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedChat?["subChats"].length ?? 0,
                  itemBuilder: (context, index) {
                    var subChat = selectedChat?["subChats"][index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage("https://via.placeholder.com/150"),
                        child: Text(subChat['name'].substring(0, 1)),
                      ),
                      title: Text(subChat["name"]),
                      subtitle: Text(subChat["lastMessage"]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(chatTitle: subChat["name"], avatarUrl: '',),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
