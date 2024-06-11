import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youth_bridge/screen/createEvent/organization/create_event.dart';
import 'package:youth_bridge/screen/createEvent/organization/create_post.dart';
import 'package:youth_bridge/widgets/themes.dart';
import 'package:youth_bridge/widgets/users_provider.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool isUser = true; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUser();
    });
  }

  Future<void> _initializeUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUserData();
    if (mounted) {
      setState(() {
        isUser = userProvider.role == 'user';
        _tabController = TabController(length: isUser ? 1 : 2, vsync: this);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (!userProvider.isAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_tabController == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Create Content',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.backgroundColor,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
          labelColor: const Color.fromARGB(255, 0, 0, 0),
          unselectedLabelColor: Color.fromARGB(123, 0, 0, 0),
          tabs: isUser
              ? [Tab(text: 'Create Post')]
              : [
                  Tab(text: 'Create Event'),
                  Tab(text: 'Create Post'),
                ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: isUser
            ? [CreatePost()]
            : [
                CreateEvent(),
                CreatePost(),
              ],
      ),
    );
  }
}
