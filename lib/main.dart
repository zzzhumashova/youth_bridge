import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_bridge/screen/authorization/forgot%20password/forgot_password_page.dart';
import 'package:youth_bridge/screen/authorization/interest_selection.dart';
import 'package:youth_bridge/screen/authorization/sign_in.dart';
import 'package:youth_bridge/screen/authorization/sign_up.dart';
import 'package:youth_bridge/screen/chats/chat_list_page.dart';
import 'package:youth_bridge/screen/createEvent/create_page.dart';
import 'package:youth_bridge/screen/homepage/home_page.dart';
import 'package:youth_bridge/screen/homepage/search_page.dart';
import 'package:youth_bridge/screen/profile/more/about_us.dart';
import 'package:youth_bridge/screen/profile/more/edit_profile.dart';
import 'package:youth_bridge/screen/profile/profile_screen.dart';
import 'package:youth_bridge/screen/splash/splash_screen.dart';
import 'package:youth_bridge/screen/vacancies/vacancies.dart';
import 'package:youth_bridge/widgets/custom_navigation_bar.dart';
import 'package:youth_bridge/widgets/users_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        home: FutureBuilder<bool>(
          future: _checkIfLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData && snapshot.data == true) {
              Provider.of<UserProvider>(context, listen: false).fetchUserData();
              return const MainScaffold(currentIndex: 0);
            } else {
              return SignIn();
            }
          },
        ),
        routes: {
          '/home': (context) => const MainScaffold(currentIndex: 0),
          '/vacancies': (context) => const MainScaffold(currentIndex: 1),
          '/create_event': (context) => const MainScaffold(currentIndex: 2),
          '/chat_list_page': (context) => const MainScaffold(currentIndex: 3),
          '/profile': (context) => const MainScaffold(currentIndex: 4),
          '/sign_in': (context) => SignIn(),
          '/sign_up': (context) => const SignUp(),
          '/splash': (context) => const SplashPage(),
          '/forgot_password_page': (context) => const ForgotPasswordPage(),
          '/edit_profile': (context) => EditProfilePage(),
          '/search': (context) => SearchPage(),
          '/about_us': (context) => AboutUsPage(),
          '/interest_selection': (context) => InterestsSelectionPage(),
        },
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  final int currentIndex;

  const MainScaffold({super.key, required this.currentIndex});

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    VacanciesPage(),
    CreatePage(),
    ChatListPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUserData();
  }

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (!userProvider.isAuthenticated) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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