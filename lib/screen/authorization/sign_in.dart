import 'package:flutter/material.dart';
import 'package:youth_bridge/widgets/themes.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Действия при нажатии кнопки входа
          },
          child: Text('Log In'),
          style: ElevatedButton.styleFrom(
            primary: AppColors.primaryColor,
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
