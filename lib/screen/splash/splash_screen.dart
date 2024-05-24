import 'package:flutter/material.dart';
import 'package:youth_bridge/widgets/themes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  int _currentPageIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPageIndex = page;
              });
            },
            children: <Widget>[
              _buildContent('assets/img/splash1.png', 'Youth Bridge',
                  'This is a platform where you will find opportunities for your development in any direction'),
              _buildContent('assets/img/splash1.png', 'Our Mission',
                  'Our mission is to empower youth by providing opportunities for personal and professional growth, fostering leadership skills, and creating a platform for meaningful connections and collaborations.'),
              _buildContent('assets/img/splash1.png', 'Start today!',
                  'Discover a world of opportunities with Youth Bridge. From career growth to personal development, our platform offers the tools and resources you need to succeed. Join us and unlock your potential today!'),
            ],
          ),
          Positioned(
            bottom: 45,
            left: 30,
            child: Row(
              children: List.generate(3, (index) => _buildDot(index)),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: _currentPageIndex != 2
                ? InkWell(
                    onTap: () {
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                    child: Container(
                      height: 38,
                      width: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 3),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/sign_in');
                    },
                    child: Container(
                      height: 38,
                      width: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 3,),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String imagePath, String title, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
        Text(
          title,
          style:
            const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,),
        Text(
          text,
          style: 
            const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
            textAlign: TextAlign.center,),
      ],
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 15,
      width: _currentPageIndex == index ? 40 : 12,
      decoration: BoxDecoration(
        color: _currentPageIndex == index ? const Color.fromARGB(255, 255, 255, 255) : Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
