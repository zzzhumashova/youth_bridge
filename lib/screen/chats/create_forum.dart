import 'package:flutter/material.dart';

class CreateForumPage extends StatelessWidget {
  final TextEditingController forumNameController = TextEditingController();
  final TextEditingController forumDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Forum'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: forumNameController,
              decoration: InputDecoration(
                labelText: 'Forum Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: forumDescriptionController,
              decoration: InputDecoration(
                labelText: 'Forum Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Логика создания нового форума
              },
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}