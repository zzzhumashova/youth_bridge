import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youth_bridge/widgets/themes.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late TextEditingController _emailController;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _emailController.addListener(_checkButtonStatus);
    _checkButtonStatus(); 
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _checkButtonStatus() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty;
    });
  }

  Future<void> _sendPasswordResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password reset email sent')));
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send email')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Icon(Icons.lock_outline, size: 60, color: AppColors.primaryColor),
            SizedBox(height: 30),
            Text(
              "Forgot your password?",
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryColor, fontSize: 24.0),
            ),
            SizedBox(height: 20),
            Text(
              "Введите свой электронный адрес и мы отправим вам код для восстановления доступа к аккаунту.",
              textAlign: TextAlign.center,
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 14.0),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter your e-mail',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: const Color.fromARGB(255, 229, 229, 229)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: const Color.fromARGB(255, 51, 51, 51)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _sendPasswordResetEmail : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isButtonEnabled ? AppColors.primaryColor : Colors.grey,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text('Send Confirmation', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign_in');
              },
              child: Text('Go back to the login page', style: TextStyle(color: AppColors.primaryColor)),
            ),
          ],
        ),
      ),
    );
  }
}
