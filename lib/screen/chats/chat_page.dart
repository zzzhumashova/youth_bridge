import 'package:flutter/material.dart';
import 'package:youth_bridge/widgets/themes.dart';

class ChatPage extends StatefulWidget {
  final String chatTitle;
  final String avatarUrl;

  ChatPage({required this.chatTitle, required this.avatarUrl});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [
    {
      "sender": "User1",
      "text": "Привет!",
      "time": "13:30",
      "isMe": false,
    },
    {
      "sender": "User2",
      "text": "Привет! Как дела?",
      "time": "13:31",
      "isMe": true,
    },
    {
      "sender": "User1",
      "text": "Все хорошо, спасибо!",
      "time": "13:32",
      "isMe": false,
    },
  ];

  void _showAttachmentMenu(BuildContext context, Offset offset) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      elevation: 0,
      surfaceTintColor: Colors.white,
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy - 200, 
        overlay.size.width - offset.dx - 50,
        offset.dy,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      items: [
        PopupMenuItem(
          value: 'gallery',
          child: ListTile(
            leading: Icon(Icons.photo),
            title: Text('Галерея'),
          ),
        ),
        PopupMenuItem(
          value: 'file',
          child: ListTile(
            leading: Icon(Icons.file_upload),
            title: Text('Файл'),
          ),
        ),
        PopupMenuItem(
          value: 'contact',
          child: ListTile(
            leading: Icon(Icons.supervisor_account),
            title: Text('Контакт'),
          ),
        ),
        PopupMenuItem(
          value: 'map',
          child: ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Карта'),
          ),
        ),
      ],
    ).then((value) {
      // Handle the selected value
      if (value != null) {
        print('Selected: $value');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.avatarUrl),
            ),
            SizedBox(width: 10),
            Text(widget.chatTitle),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages[index];
                return ChatBubble(
                  text: message['text'],
                  isMe: message['isMe'],
                  time: message['time'],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: () {
                      final RenderBox button = context.findRenderObject() as RenderBox;
                      final RenderBox overlay =
                          Overlay.of(context).context.findRenderObject() as RenderBox;
                      final Offset offset = button.localToGlobal(Offset.zero, ancestor: overlay);
                      final Size buttonSize = button.size;

                      _showAttachmentMenu(
                        context,
                        Offset(offset.dx, offset.dy - buttonSize.height - 10),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Сообщение',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send_rounded),
                  onPressed: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      setState(() {
                        messages.add({
                          "sender": "Me",
                          "text": _messageController.text,
                          "time": TimeOfDay.now().format(context),
                          "isMe": true,
                        });
                        _messageController.clear();
                      });
                    }
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

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;

  ChatBubble({required this.text, required this.isMe, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[100] : Colors.grey[300],
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 5.0),
            Text(
              time,
              style: TextStyle(fontSize: 12.0, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
