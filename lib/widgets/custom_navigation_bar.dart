import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:youth_bridge/widgets/themes.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({super.key, 
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: AppColors.backgroundColor,
      index: currentIndex,
      height: 55,
      items: <Widget>[
        Icon(Icons.home, size: 30),
        Icon(Icons.lightbulb, size: 30),
        Icon(Icons.add, size: 30),
        Icon(Icons.forum, size: 30),
        Icon(Icons.person, size: 30),
      ],
      onTap: (index) {
        onTap(index);
      },
      animationDuration: Duration(milliseconds: 300),
    );
  }
}

