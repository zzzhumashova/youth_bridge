import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youth_bridge/widgets/themes.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String code;

  ResetPasswordPage({required this.email, required this.code});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _resetPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match')));
      return;
    }
    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: widget.code,
        newPassword: _passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password reset successful')));
      Navigator.pushNamed(context, '/sign_in');
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to reset password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Enter new password',
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
                ),),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm new password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Save Password'),
            ),
          ],
        ),
      ),
    );
  }
}

