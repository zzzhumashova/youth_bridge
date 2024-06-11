import 'package:flutter/material.dart';
import 'package:youth_bridge/models/post_models.dart';
import 'package:youth_bridge/screen/profile/post_feed.dart/post_detail.dart';

class UserPostsWidget extends StatelessWidget {
  final List<PostModel> posts;

  UserPostsWidget({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailPage(postModel:  posts[index],),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(posts[index].mediaUrls.isNotEmpty
                    ? posts[index].mediaUrls[0]
                    : 'https://via.placeholder.com/150'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      },
    );
  }
}
