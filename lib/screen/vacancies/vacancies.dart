import 'package:flutter/material.dart';
import 'package:youth_bridge/screen/vacancies/vacancy_card.dart';
import 'package:youth_bridge/widgets/themes.dart';

class VacanciesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: Text('VacanciesPage',style: TextStyle(fontWeight: FontWeight.bold),),backgroundColor:AppColors.backgroundColor,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
          },
        ),
      ],
      automaticallyImplyLeading: false,),
      body: ListView(
        children: [
          VacancyCard(
            title: "Senior Software Engineer",
            companyName: "Tech Innovations Inc.",
            location: "New York, NY",
            salary: "\$120,000 - \$150,000",
            description: "Join our team to innovate and develop cutting-edge solutions...",
          ),
          VacancyCard(
            title: "Volunteers to organize the event",
            companyName: "EventKz",
            location: "Almaty, Kazakhstan",
            salary: " ",
            description: "Manage projects and lead teams to success in a dynamic environment...",
          ),
          VacancyCard(
            title: "Project Manager",
            companyName: "Creative Solutions Ltd.",
            location: "Remote",
            salary: "\$95,000 - \$120,000",
            description: "Manage projects and lead teams to success in a dynamic environment...",
          ),
          VacancyCard(
            title: "Volunteers",
            companyName: "AWSD Youth Movement",
            location: "Astana, Kazakhstan",
            salary: " ",
            description: "Manage projects and lead teams to success in a dynamic environment...",
          ),
        ],
      ),
    );
  }
}
