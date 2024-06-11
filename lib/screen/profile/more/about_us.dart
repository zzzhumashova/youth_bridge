import 'package:flutter/material.dart';
import 'package:youth_bridge/widgets/themes.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset('assets/img/logo_white.png', height: 100),
                  SizedBox(height: 10),
                  Text(
                    'Youth Bridge',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'What We Do',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Youth Bridge is a platform that connects young people with opportunities for personal and professional development. We offer information on educational programs, volunteer opportunities, scholarships, and events in sectors like education, sports, culture, and finance.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Mission Statement & Values',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Our mission is to empower youth to reach their full potential by providing access to valuable resources and opportunities. We value education, community engagement, and personal growth.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Our History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Youth Bridge was founded in 2024 with the aim of bridging the gap between young individuals and the opportunities available to them. Since then, we have grown to include a wide range of services and resources.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Our Services',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We provide:\n- Secure user authentication\n- Personalized content feeds\n- Strong search and filter functions\n- Real-time communication via chats and forums\n- Comprehensive profile management',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Testimonials',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '“Youth Bridge has significantly improved my access to development opportunities. I have found numerous programs and events that have helped me grow personally and professionally.” - A satisfied user',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Contact Us',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Address: 123 Main Street, Your City\nPhone: (123) 456-7890\nEmail: info@youthbridge.com',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Follow Us',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.facebook),
                  onPressed: () {
                    // Link to Facebook
                  },
                ),
                // IconButton(
                //   icon: Icon(Icons.soci),
                //   onPressed: () {
                //     // Link to Instagram
                //   },
                // ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Awards & Recognition',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We are proud to have received the Best Youth Development Platform award in 2024 for our outstanding contributions to youth empowerment.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
