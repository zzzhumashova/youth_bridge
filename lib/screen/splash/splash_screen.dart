import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:youth_bridge/screen/authorization/sign_in.dart';
import 'package:youth_bridge/screen/homepage/home_page.dart';
import 'package:youth_bridge/widgets/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  int _currentPageIndex = 0;
   late AnimationController _controller;  
  late Animation<double> _progressAnimation;  
  Color backgroundColor = AppColors.secondaryColor;
  String titleText = 'Youth Bridge';
  String descriptionText =
      'This is a platform where you will find opportunities for your development in any direction';

 void initState() {
  super.initState();
  _controller = AnimationController(
    duration: const Duration(milliseconds: 300), 
    vsync: this,
  )..addListener(() {
    setState(() {}); 
  });

  _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));

  _checkLoginStatus();
}


  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false; 
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  void _nextPage() {
    if (_currentPageIndex < 2) { 
      setState(() {
        _currentPageIndex++;
        _controller.animateTo((_currentPageIndex + 1) / 3); 
        if (_currentPageIndex == 1) {
          titleText = 'Our Mission';
          descriptionText = 'Our mission is to empower youth by providing opportunities for personal and professional growth, fostering leadership skills, and creating a platform for meaningful connections and collaborations.'; 
        } else if (_currentPageIndex == 2) {
          titleText = 'Start today!';
          descriptionText = 'Discover a world of opportunities with Youth Bridge. From career growth to personal development, our platform offers the tools and resources you need to succeed. Join us and unlock your potential today!';
        }
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/splash1.png', width: MediaQuery.of(context).size.width * 0.7,),
            const SizedBox(height: 20),
            Text(
              titleText,
              style: const TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              descriptionText, 
              style: const TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 5,
              child: CustomPaint(
                painter: WaveProgressPainter(
                  waveAnimation: _controller.value,
                  progress: _progressAnimation.value,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _currentPageIndex < 2 ? _nextPage : () {},
              child: const Text('next', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 1.0, 50), 
                backgroundColor: AppColors.primaryColor,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveProgressPainter  extends CustomPainter {
  final double waveAnimation, progress;
  final Color color;

  WaveProgressPainter({required this.waveAnimation, required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();
    double waveLength = size.width / 2;
    double waveHeight = 10;

    path.moveTo(0, size.height);
    path.lineTo(0, size.height * (1 - progress));

    for (double i = 0; i < size.width; i++) {
      path.lineTo(i, size.height * (1 - progress) + sin((i / waveLength * 2 * math.pi) + waveAnimation) * waveHeight);
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WaveProgressPainter oldDelegate) {
    return oldDelegate.waveAnimation != waveAnimation || oldDelegate.progress != progress;
  }
}
