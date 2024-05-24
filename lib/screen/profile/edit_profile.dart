import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youth_bridge/widgets/themes.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final List<TextEditingController> _mainPointsControllers = List.generate(3, (index) => TextEditingController());

  late String _imagePath = 'assets/img/splash1.png';

  Future<void> _pickImage() async {
  try {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  } catch (e) {
    print('Error picking image: $e');
  }
}

  @override
  void dispose() {
    _usernameController.dispose();
    _roleController.dispose();
    _aboutController.dispose();
    _mainPointsControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(_imagePath),
                    // Для пользовательского изображения:
                    // backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.edit),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextButton(
                child: Text('Edit Photo',style: TextStyle(color: AppColors.primaryColor),
                textAlign: TextAlign.center, ),
                onPressed: _pickImage,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _roleController,
                decoration: InputDecoration(labelText: 'Role'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _aboutController,
                decoration: InputDecoration(labelText: 'About'),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              Text(
                'Три главных пункта о себе или о организации:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Column(
                children: List.generate(3, (index) {
                  return TextField(
                    controller: _mainPointsControllers[index],
                    decoration: InputDecoration(labelText: 'Point ${index + 1}'),
                  );
                }),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Логика для сохранения данных профиля
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
