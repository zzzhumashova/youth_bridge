import 'package:flutter/material.dart';
import 'package:youth_bridge/widgets/themes.dart';

class CreateEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: const Text('Home Page'),
      ),
    );
  }
}