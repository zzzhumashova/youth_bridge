import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youth_bridge/widgets/themes.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _selectedType;
  bool _isLoading = false;
  List<String> eventTypes = [
    'Education',
    'Sport',
    'Culture',
    'Art',
    'Technology'
  ];

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.red, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
      ),
    );
  }

  void _showSnackBar(String message, Color backgroundColor) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<void> _createEvent() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      if (userId.isEmpty) {
        throw Exception("User is not authenticated.");
      }

      DocumentReference eventRef = FirebaseFirestore.instance.collection('events').doc();
      await eventRef.set({
        'authorId': userId,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'date': _dateController.text,
        'location': _locationController.text,
        'price': _priceController.text,
        'eventType': _selectedType,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _showSnackBar('Event Created Successfully', Colors.green);

      setState(() {
        _titleController.clear();
        _descriptionController.clear();
        _dateController.clear();
        _locationController.clear();
        _priceController.clear();
        _selectedType = null;
      });
    } catch (e) {
      print('Error creating event: $e');
      _showSnackBar('Failed to create event: $e', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor, // Цвет фона заголовка
              onPrimary: Colors.white, // Цвет текста заголовка
              surface: Colors.white, // Цвет фона календаря
              onSurface: Colors.black, // Цвет текста дней
            ),
            dialogBackgroundColor: Colors.white, // Цвет фона диалога
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _titleController,
              decoration: _buildInputDecoration('Event Title'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter event title';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _descriptionController,
              decoration: _buildInputDecoration('Description'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _dateController,
              decoration: _buildInputDecoration('Date'),
              readOnly: true,
              onTap: () => _pickDate(context),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _locationController,
              decoration: _buildInputDecoration('Location'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a location';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _priceController,
              decoration: _buildInputDecoration('Price (\$)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a price';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            DropdownButtonFormField(
              elevation: 1,
              dropdownColor: Colors.white,
              value: _selectedType,
              decoration: _buildInputDecoration('Event Type'),
              items: eventTypes.map((String category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedType = newValue;
                });
                FocusScope.of(context).requestFocus(FocusNode());
              },
              validator: (value) {
                if (value == null) {
		              return 'Please select event type';
                }
                return null;
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _createEvent,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : const Text('Create Event', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}