import 'package:flutter/material.dart';
import 'package:youth_bridge/widgets/themes.dart';

class VacancyCard extends StatelessWidget {
  final String title;
  final String companyName;
  final String location;
  final String salary;
  final String description;

  const VacancyCard({
    Key? key,
    required this.title,
    required this.companyName,
    required this.location,
    required this.salary,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal:10, vertical: 5),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              companyName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey),
                SizedBox(width: 8), 
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Expanded(child: Container()),
                Text(
                  salary,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                minimumSize: const Size(double.infinity, 40),
              ),
              onPressed: () {  },
              child: const Text('Respond', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),

            // SizedBox(height: 16),
            // Text(
            //   description,
            //   maxLines: 3,
            //   overflow: TextOverflow.ellipsis,
            //   style: TextStyle(
            //     fontSize: 16,
            //     color: Colors.black87,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
