import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:youth_bridge/widgets/themes.dart';
import 'package:youth_bridge/widgets/users_provider.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _aboutUserController = TextEditingController();
  final TextEditingController _appBarTextController = TextEditingController();
  final List<TextEditingController> _mainPointsControllers = List.generate(3, (index) => TextEditingController());

  late Color _appBarColor;
  late String _appBarImagePath;
  late Color _avatarColor;
  late String _avatarImagePath;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _usernameController.text = userProvider.name;
    _roleController.text = userProvider.role;
    _aboutUserController.text = userProvider.aboutUser;
    _appBarTextController.text = userProvider.appBarText;
    _appBarColor = Color(int.parse(userProvider.appBarColor.replaceFirst('#', '0xff')));
    _avatarColor = Color(int.parse(userProvider.avatarColor.replaceFirst('#', '0xff')));
    _avatarImagePath = userProvider.avatarUrl;
    _appBarImagePath = userProvider.appBarImage;
  }

  Future<void> _pickImageAppBar() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _appBarImagePath = pickedFile.path;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _pickAvatarImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _avatarImagePath = pickedFile.path;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _pickAppBarColor() async {
    Color tempColor = _appBarColor;

    Color? pickedColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (Color color) {
                tempColor = color;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Select'),
              onPressed: () {
                Navigator.of(context).pop(tempColor);
              },
            ),
          ],
        );
      },
    );

    if (pickedColor != null) {
      setState(() {
        _appBarColor = pickedColor;
      });
    }
  }

  Future<void> _pickAvatarColor() async {
    Color tempColor = _avatarColor;

    Color? pickedColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (Color color) {
                tempColor = color;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Select'),
              onPressed: () {
                Navigator.of(context).pop(tempColor);
              },
            ),
          ],
        );
      },
    );

    if (pickedColor != null) {
      setState(() {
        _avatarColor = pickedColor;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _roleController.dispose();
    _aboutUserController.dispose();
    _appBarTextController.dispose();
    _mainPointsControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.updateAppBarSettings(
      '#${_appBarColor.value.toRadixString(16)}',
      _appBarTextController.text,
      _appBarImagePath,
    );
    await userProvider.updateAboutUser(_aboutUserController.text);
    await userProvider.updateAvatarColor('#${_avatarColor.value.toRadixString(16)}');
    await userProvider.updateAvatarUrl(_avatarImagePath);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text('Edit Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                    onPressed: _pickAppBarColor,
                    child: Text('Pick AppBar Color', style: TextStyle(fontSize: 16, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 20),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: _avatarColor,
                    backgroundImage: _avatarImagePath.isNotEmpty ? FileImage(File(_avatarImagePath)) : null,
                    child: _avatarImagePath.isEmpty
                        ? Text(
                            _usernameController.text.isNotEmpty ? _usernameController.text.substring(0, 1) : '',
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: _pickAvatarColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextButton(
                child: Text('Edit Photo', style: TextStyle(color: AppColors.primaryColor)),
                onPressed: _pickAvatarImage,
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
                controller: _aboutUserController,
                decoration: InputDecoration(labelText: 'About'),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _appBarTextController,
                decoration: InputDecoration(labelText: 'AppBar Text'),
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Text(
                'Three main points about yourself or your organization:',
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
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
