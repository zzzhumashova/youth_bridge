
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: ListView.builder(
        itemCount: 10, 
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('News ${index + 1}'), 
            subtitle: Text('Description of News ${index + 1}'), 
            onTap: () {
              // Действие при нажатии на новость, например, переход на детальную страницу новости
            },
          );
        },
      ),
    );
  }
}
