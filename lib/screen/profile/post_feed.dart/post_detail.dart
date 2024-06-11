import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:youth_bridge/models/post_models.dart';
import 'package:youth_bridge/widgets/themes.dart';
import 'package:youth_bridge/widgets/users_provider.dart';

class PostDetailPage extends StatelessWidget {
  final PostModel postModel;

  PostDetailPage({required this.postModel,});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final String authorId = postModel.authorId;
    bool isCurrentUserPost = authorId == userProvider.userId;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text('Post Details', style: TextStyle(fontWeight: FontWeight.bold),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 20,
                  backgroundColor: isCurrentUserPost
                      ? Color(int.parse(
                          userProvider.avatarColor.replaceFirst('#', '0xff')))
                      : Colors.grey,
                  backgroundImage:
                      isCurrentUserPost && userProvider.avatarUrl.isNotEmpty
                          ? NetworkImage(userProvider.avatarUrl)
                          : null,
                  child: !isCurrentUserPost || userProvider.avatarUrl.isEmpty
                      ? Text(
                          userProvider.name.isNotEmpty
                              ? userProvider.name[0]
                              : '',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )
                      : null,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(userProvider.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Icon(Icons.more_vert),
              ],
            ),
            CarouselSlider(
              options: CarouselOptions(
                  height: 400.0,
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0),
              items: postModel.mediaUrls.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
                IconButton(icon: Icon(Icons.comment), onPressed: () {}),
                IconButton(icon: Icon(Icons.send_rounded), onPressed: () {}),
                Spacer(),
                IconButton(icon: Icon(Icons.bookmark_border), onPressed: () {}),
                // ElevatedButton(
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     primary: Colors.blue,
                //   ),
                //   child:
                //       Text('Participate', style: TextStyle(color: Colors.white)),
                // ),
              ],
            ),
            Text("${userProvider.name}:${postModel.description}",
                style: TextStyle(color: Colors.black)),
            Text(
              'Published: ${DateFormat('yyyy-MM-dd – kk:mm').format(postModel.timestamp.toDate())}',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
