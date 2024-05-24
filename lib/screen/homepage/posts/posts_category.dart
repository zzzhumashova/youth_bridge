import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youth_bridge/models/post_models.dart';
import 'package:youth_bridge/screen/homepage/posts/posts.dart';

class PostsCategoryWidget extends StatelessWidget {
  final String category;

  PostsCategoryWidget({required this.category});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts')
                .where('category', isEqualTo: category)
                .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Пока нет никаких постов'));
        }

        var posts = snapshot.data!.docs
                    .map((doc) => PostsModel.fromFirestore(doc.data() as Map<String, dynamic>))
                    .toList();

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return PostsWidget(postsModel: posts[index]);
          },
        );
      },
    );
  }
}

