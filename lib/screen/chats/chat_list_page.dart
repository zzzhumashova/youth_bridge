import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youth_bridge/screen/chats/chat_list.dart';
import 'package:youth_bridge/screen/chats/create_forum.dart';
import 'package:youth_bridge/screen/chats/forum_list.dart';
import 'package:youth_bridge/widgets/themes.dart';
import 'package:youth_bridge/widgets/users_provider.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    String userRole = Provider.of<UserProvider>(context).name;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Chats', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.backgroundColor,
        automaticallyImplyLeading: false,
        actions: [
          if (userRole == 'organization')
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateForumPage(),
                  ),
                );
              },
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.black, width: 2.0), 
          ),
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black54),
          tabs: [
            Tab(text: 'Personal'),
            Tab(text: 'Forum'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PersonalChat(),
          ForumChat(),
        ],
      ),
    );
  }
}
