import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youth_bridge/widgets/themes.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController orgNameController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureRepeatPassword = true;
  late TabController _tabController;
  String? selectedSector;

  List<String> sectors = [
    'Education',
    'Sports',
    'Culture',
    'Fashion',
    'Creative Arts',
    'Finance',
    'Technology',
    'Health & Wellness',
    'Entrepreneurship',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  Future<bool> checkEmailExists(String email) async {
    final apiKey = '7880b98741745e2104eba80a8c499c213fe1af92';
    final url = 'https://api.hunter.io/v2/email-verifier?email=$email&api_key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['data']['result'] == 'deliverable';
    } else {
      throw Exception('Failed to verify email');
    }
  }

  Future<void> _signUpWithEmailAndPassword(BuildContext context) async {
    try {
      if (passwordController.text != repeatPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords do not match'),
          ),
        );
        return;
      }

      bool emailExists = await checkEmailExists(emailController.text);
      if (!emailExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email does not exist'),
          ),
        );
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      String role = _tabController.index == 0 ? 'user' : 'organization';
      String name = _tabController.index == 0 ? '${firstNameController.text} ${lastNameController.text}' : orgNameController.text;
      
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'email': emailController.text,
        'role': role,
        'name': name,
        if (_tabController.index == 1) 'sector': selectedSector,
      });

      print('Sign up successful: ${userCredential.user!.uid}');
      Navigator.pushReplacementNamed(context, '/interest_selection');
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else {
        errorMessage = 'An unknown error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    } catch (e) {
      print('Error during sign up: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
        ),
      );
    }
  }

  Widget buildTextField({required TextEditingController controller, required String hintText, bool obscureText = false, IconButton? suffixIcon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Color.fromARGB(133, 255, 255, 255)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        fillColor: Colors.transparent,
        suffixIcon: suffixIcon,
      ),
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/img/logo_white.png',
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 40),
                const Text(
                  'Register Form',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                    labelColor: Colors.white,
                    unselectedLabelColor: Color.fromARGB(124, 255, 255, 255),
                    tabs: [
                      Tab(text: 'User'),
                      Tab(text: 'Organization'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (_tabController.index == 0) ...[
                  buildTextField(controller: firstNameController, hintText: 'First Name'),
                  const SizedBox(height: 10),
                  buildTextField(controller: lastNameController, hintText: 'Last Name'),
                ] else ...[
                  buildTextField(controller: orgNameController, hintText: 'Organization Name'),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedSector,
                    items: sectors.map((String sector) {
                      return DropdownMenuItem<String>(
                        value: sector,
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(sector),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSector = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Select Sector',
                      hintStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      fillColor: Colors.transparent,
                    ),
                    style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                    dropdownColor: AppColors.primaryColor,
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  ),
                ],
                const SizedBox(height: 10),
                buildTextField(controller: emailController, hintText: 'Enter e-mail'),
                const SizedBox(height: 10),
                buildTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                buildTextField(
                  controller: repeatPasswordController,
                  hintText: 'Repeat password',
                  obscureText: _obscureRepeatPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureRepeatPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureRepeatPassword = !_obscureRepeatPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    _signUpWithEmailAndPassword(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Register', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/sign_in');
                  },
                  child: const Text(
                    "Do you have an account? Sign In",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
