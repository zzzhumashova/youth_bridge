import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youth_bridge/widgets/themes.dart';

class InterestsSelectionPage extends StatefulWidget {
  @override
  _InterestsSelectionPageState createState() => _InterestsSelectionPageState();
}

class _InterestsSelectionPageState extends State<InterestsSelectionPage> {
  final List<String> sectors = [
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

  final List<String> selectedSectors = [];

  void _onInterestTap(String sector) {
    setState(() {
      if (selectedSectors.contains(sector)) {
        selectedSectors.remove(sector);
      } else {
        selectedSectors.add(sector);
      }
    });
  }

  void _onSubmit() {
    if (selectedSectors.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least 3 interests.'),
        ),
      );
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'interests': selectedSectors,
      }).then((_) {
        Navigator.pushReplacementNamed(context, '/home');
      }).catchError((error) {
        print('Error updating interests: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update interests. Please try again.'),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 50,),
            Text(
              'Выберите ваши интересы',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 3,),
            Text(
              'Это поможет нам в персонализации',
              style: TextStyle(fontSize: 16,),
            ),
            SizedBox(height: 3,),
            Text(
              'Выберите минимум 3 сектора',
              style: TextStyle(fontSize: 12,color: AppColors.primaryColor),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: sectors.length,
                itemBuilder: (context, index) {
                  final sector = sectors[index];
                  final isSelected = selectedSectors.contains(sector);
                  return GestureDetector(
                    onTap: () => _onInterestTap(sector),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isSelected ? AppColors.primaryColor.withOpacity(0.7) : Colors.grey[300],
                        border: isSelected ? Border.all(color: AppColors.primaryColor, width: 2) : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            // 'assets/icons/${sector.toLowerCase().replaceAll(' ', '_')}.png',
                            'assets/img/splash1.png',
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(height: 10),
                          Text(
                            sector,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _onSubmit,
              style: ElevatedButton.styleFrom(
                primary: AppColors.primaryColor,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Submit', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
