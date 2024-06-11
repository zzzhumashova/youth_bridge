import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youth_bridge/screen/profile/calendar/calendar_page.dart';
import 'package:youth_bridge/screen/profile/post_feed.dart/post_detail.dart';
import 'package:youth_bridge/widgets/themes.dart';
import 'package:youth_bridge/widgets/users_provider.dart';
import 'package:youth_bridge/models/post_models.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<List<PostModel>> fetchUserPosts(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('authorId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => PostModel.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Error fetching user posts: $e');
      throw Exception('Error fetching user posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserProvider>(context).userId;
    String name = Provider.of<UserProvider>(context).name;
    String role = Provider.of<UserProvider>(context).role;
    String aboutUser = Provider.of<UserProvider>(context).aboutUser;
    List<String> interests = Provider.of<UserProvider>(context).interests;
    String appBarText = Provider.of<UserProvider>(context).appBarText;
    Color appBarColor = Color(int.parse(Provider.of<UserProvider>(context)
        .appBarColor
        .replaceFirst('#', '0xff')));
    String appBarImage = Provider.of<UserProvider>(context).appBarImage;
    Color avatarColor = Color(int.parse(Provider.of<UserProvider>(context)
        .avatarColor
        .replaceFirst('#', '0xff')));
    String avatarUrl = Provider.of<UserProvider>(context).avatarUrl;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            backgroundColor: appBarColor,
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(appBarText, textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              background: appBarImage.isNotEmpty
                  ? Image.file(
                      File(appBarImage),
                      fit: BoxFit.cover,
                    )
                  : Container(color: appBarColor),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.menu),
                color: AppColors.primaryColor,
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    context: context,
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Edit Profile'),
                            onTap: () {
                              Navigator.pushNamed(context, '/edit_profile');
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.error_outline),
                            title: Text('About Us'),
                            onTap: () {
                              Navigator.pushNamed(context, '/about_us');
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.logout),
                            title: Text('Logout'),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: const Column(
                                      children: [
                                        Icon(Icons.warning,
                                            color: AppColors.primaryColor,
                                            size: 50),
                                        SizedBox(height: 10),
                                        Text(
                                          'Вы уверены, что хотите выйти?',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Это действие не может быть отменено.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          TextButton(
                                            child: Text(
                                              'Отмена',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25, vertical: 10),
                                              primary: Colors.black,
                                              backgroundColor: Colors.grey[300],
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'Выйти',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25, vertical: 10),
                                              primary: Colors.white,
                                              backgroundColor:
                                                  AppColors.primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      '/sign_in');
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: avatarColor,
                    backgroundImage:
                        avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                    child: avatarUrl.isEmpty
                        ? Text(
                            name.isNotEmpty ? name[0] : '',
                            style: TextStyle(fontSize: 40, color: Color.fromARGB(255, 255, 255, 255)),
                          )
                        : null,
                  ),
                  SizedBox(height: 10),
                  Text(name,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 3),
                  Text(role == 'user' ? 'User' : 'Organization',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  SizedBox(height: 10),
                  Text(
                    aboutUser.isEmpty ? " " : aboutUser,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text('0',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text('Followers')
                          ],
                        ),
                        Column(
                          children: [
                            Text('0',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text('Following')
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CalendarPage()),
                            );
                          },
                          child: Column(
                            children: [
                              Text('0',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text('Upcoming events'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    interests.isEmpty
                        ? 'No interests selected.'
                        : interests.join('\n'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 10),
                  Divider(height: 0 / 5, color: Colors.black12),
                  FutureBuilder<List<PostModel>>(
                    future: fetchUserPosts(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error loading posts'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('No posts available'),
                        );
                      } else {
                        final posts = snapshot.data!;
                        return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                          ),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostDetailPage(
                                      postModel: posts[index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(posts[index].mediaUrls[0]),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
