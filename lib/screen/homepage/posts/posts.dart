import 'package:flutter/material.dart';
import 'package:youth_bridge/models/post_models.dart';

class PostsWidget extends StatelessWidget {
  final PostsModel postsModel;

  PostsWidget({required this.postsModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(postsModel.avatarUrl),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(postsModel.username, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(postsModel.city, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 12),
          if (postsModel.photoUrl != null)
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(postsModel.photoUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
              IconButton(icon: Icon(Icons.comment), onPressed: () {}),
              IconButton(icon: Icon(Icons.share), onPressed: () {}),
            ],
          ),
          Text(postsModel.description, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
