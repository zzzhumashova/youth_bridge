import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_bridge/screen/authorization/forgot%20password/forgot_password_page.dart';
import 'package:youth_bridge/screen/chats/chat_list_page.dart';
import 'package:youth_bridge/screen/createEvent/create_event.dart';
import 'package:youth_bridge/screen/homepage/home_page.dart';
import 'package:youth_bridge/screen/homepage/search_page.dart';
import 'package:youth_bridge/screen/profile/edit_profile.dart';
import 'package:youth_bridge/screen/profile/profile_screen.dart';
import 'package:youth_bridge/screen/vacancies/vacancies.dart';
import 'package:youth_bridge/screen/authorization/sign_in.dart';
import 'package:youth_bridge/screen/authorization/sign_up.dart';
import 'package:youth_bridge/screen/splash/splash_screen.dart';
import 'package:youth_bridge/widgets/custom_navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> _checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<bool>(
        future: _checkIfLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data == true) {
            return MainScaffold(currentIndex: 0);
          } else {
            return SignIn();
          }
        },
      ),
      routes: {
        '/home': (context) => MainScaffold(currentIndex: 0),
        '/vacancies': (context) => MainScaffold(currentIndex: 1),
        '/create_event': (context) => MainScaffold(currentIndex: 2),
        '/chat_list_page': (context) => MainScaffold(currentIndex: 3),
        '/profile': (context) => MainScaffold(currentIndex: 4),
        '/sign_in': (context) => SignIn(),
        '/sign_up': (context) => SignUp(),
        '/splash': (context) => SplashPage(),
        '/forgot_password_page': (context) => ForgotPasswordPage(),
        '/edit_profile': (context) => EditProfilePage(),
        '/search': (context) => SearchPage(),
      },
    );
  }
}

class MainScaffold extends StatefulWidget {
  final int currentIndex;

  MainScaffold({required this.currentIndex});

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    VacanciesPage(),
    CreateEvent(),
    ChatListPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _changePage,
      ),
    );
  }
}
