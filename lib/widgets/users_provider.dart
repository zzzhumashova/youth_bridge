import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _name;
  String? _role;
  bool _isAuthenticated = false;
  String? _aboutUser;
  List<String> _interests = [];
  String? _appBarText;
  late String _appBarColor;
  late String _appBarImage;
  late String _avatarColor;
  late String _avatarUrl;
  late String _userId;
  List<String> _subscriptions = [];

  String get name => _name ?? '';
  String get role => _role ?? '';
  bool get isAuthenticated => _isAuthenticated;
  String get aboutUser => _aboutUser ?? '';
  List<String> get interests => _interests;
  String get appBarText => _appBarText ?? '';
  String get appBarColor => _appBarColor;
  String get appBarImage => _appBarImage;
  String get avatarColor => _avatarColor;
  String get avatarUrl => _avatarUrl;
  String get userId => _userId;
  List<String> get subscriptions => _subscriptions;

  Future<void> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      _name = userData.containsKey('role') && userData['role'] == 'user'
          ? userData['name']
          : userData['name'];
      _role = userData['role'];
      _aboutUser = userData.containsKey('aboutUser') ? userData['aboutUser'] : '';
      _interests = userData.containsKey('interests') ? List<String>.from(userData['interests']) : [];
      _appBarText = userData.containsKey('appBarText') ? userData['appBarText'] : '';
      _appBarColor = userData.containsKey('appBarColor') ? userData['appBarColor'] : '#FFFFFF';
      _appBarImage = userData.containsKey('appBarImage') ? userData['appBarImage'] : '';
      _avatarColor = userData.containsKey('avatarColor') ? userData['avatarColor'] : '#FFFFFF';
      _avatarUrl = userData.containsKey('avatarUrl') ? userData['avatarUrl'] : '';
      _userId = userId;
      _subscriptions = userData.containsKey('subscriptions') ? List<String>.from(userData['subscriptions']) : [];

      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<void> updateAppBarSettings(String color, String text, String imagePath) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'appBarColor': color,
        'appBarText': text,
        'appBarImage': imagePath,
      });
      _appBarColor = color;
      _appBarText = text;
      _appBarImage = imagePath;
      notifyListeners();
    }
  }

  Future<void> updateAboutUser(String aboutUser) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'aboutUser': aboutUser,
      });
      _aboutUser = aboutUser;
      notifyListeners();
    }
  }

  Future<void> updateAvatarColor(String color) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'avatarColor': color,
      });
      _avatarColor = color;
      notifyListeners();
    }
  }

  Future<void> updateAvatarUrl(String url) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'avatarUrl': url,
      });
      _avatarUrl = url;
      notifyListeners();
    }
  }

  void setAboutUser(String text) {
    _aboutUser = text;
    notifyListeners();
  }

  void setInterests(List<String> interests) {
    _interests = interests;
    notifyListeners();
  }
}
