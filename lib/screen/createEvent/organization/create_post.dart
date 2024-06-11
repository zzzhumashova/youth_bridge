import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:youth_bridge/widgets/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _descriptionController = TextEditingController();
  final List<XFile> _mediaFiles = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickMedia() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 88,
      );
      if (pickedFiles != null) {
        setState(() {
          _mediaFiles.addAll(pickedFiles);
        });
      }
    } catch (e) {
      print('Error picking media: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick media: $e')),
      );
    }
  }

    Future<void> _createPost() async {
    if (_descriptionController.text.isEmpty || _mediaFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add a description and at least one image')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      List<String> mediaUrls = [];
      for (var file in _mediaFiles) {
        File imageFile = File(file.path);
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        UploadTask uploadTask = FirebaseStorage.instance.ref('posts/$fileName').putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        String url = await taskSnapshot.ref.getDownloadURL();
        mediaUrls.add(url);
      }

      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      if (userId.isEmpty) {
        throw Exception("User is not authenticated.");
      }

      DocumentReference postRef = FirebaseFirestore.instance.collection('posts').doc();
      await postRef.set({
        'authorId': userId,
        'description': _descriptionController.text,
        'mediaUrls': mediaUrls,
        'timestamp': FieldValue.serverTimestamp(),
      });


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post Created Successfully'),
          duration: Duration(seconds: 3),
        ),
      );

      setState(() {
        _descriptionController.clear();
        _mediaFiles.clear();
      });
    } catch (e) {
      print('Error creating post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create post: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (_mediaFiles.isNotEmpty)
            Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(height: 400.0, enableInfiniteScroll: false, viewportFraction: 1.0),
                  items: _mediaFiles.map((file) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 1.0),
                              decoration: const BoxDecoration(color: Colors.black12),
                              child: Image.file(File(file.path), height: 400.0, width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _mediaFiles.remove(file);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(1),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.close, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }).toList(),
                ),
                Positioned(
                  height: 30,
                  width: 30,
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton(
                    shape: const CircleBorder(side: BorderSide.none),
                    onPressed: _pickMedia,
                    elevation: 0,
                    backgroundColor: AppColors.primaryColor,
                    child: const Icon(Icons.add, size: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          if (_mediaFiles.isEmpty)
            TextButton(
              onPressed: _pickMedia,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.transparent),
                ),
                minimumSize: Size(double.infinity, 150),
              ),
              child: Icon(Icons.add, size: 30),
            ),
          SizedBox(height: 20),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Tell something about the event or your organization...',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.transparent, width: 2.0),
              ),
            ),
            maxLines: null,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: _isLoading ? null : _createPost,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: _isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : const Text('Create Post', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
