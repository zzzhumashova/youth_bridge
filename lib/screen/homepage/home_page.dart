import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youth_bridge/models/news_article.dart';
import 'package:youth_bridge/models/post_models.dart';
import 'package:youth_bridge/screen/homepage/posts/posts.dart';
import 'package:youth_bridge/screen/homepage/search_page.dart';
import 'package:youth_bridge/widgets/themes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:youth_bridge/widgets/users_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<NewsArticle>> _newsFuture;
  late Future<List<PostModel>> _postsFuture;
  FocusNode _homeSearchFocusNode = FocusNode();
  String currentCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _newsFuture = fetchNews();
    _postsFuture = fetchPosts();
  }

  @override
  void dispose() {
    _homeSearchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Youth Bridge',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backgroundColor,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                focusNode: _homeSearchFocusNode,
                onTap: () async {
                  _homeSearchFocusNode.unfocus();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<List<NewsArticle>>(
              future: _newsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                } else if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return _buildNewsFeed([]);
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  print('No news available');
                  return _buildNewsFeed([]);
                } else {
                  final newsArticles = snapshot.data!;
                  return _buildNewsFeed(newsArticles);
                }
              },
            ),
          ),
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppColors.primaryColor,
                tabs: [
                  _buildTab(text: 'All', index: 0),
                  _buildTab(text: 'Sport', index: 1),
                  _buildTab(text: 'Education', index: 2),
                  _buildTab(text: 'Grants', index: 3),
                  _buildTab(text: 'Volunteering', index: 4),
                  _buildTab(text: 'Travel', index: 5),
                  _buildTab(text: 'Science', index: 6),
                ],
                onTap: (index) {
                  setState(() {
                    currentCategory = _tabController.index == 0 ? 'All' : _tabController.index.toString();
                    _postsFuture = fetchPosts();
                  });
                },
              ),
            ),
            pinned: true,
          ),
        ],
        body: FutureBuilder<List<PostModel>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: AppColors.backgroundColor,
                  color: AppColors.primaryColor,
                ),
              );
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Center(child: Text('Error loading posts'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No posts available'));
            } else {
              final posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return PostWidget(postModel: posts[index]);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildNewsFeed(List<NewsArticle> newsArticles) {
    var validArticles = newsArticles.where((article) => article.title != '[Removed]' && article.description != '[Removed]').toList();

    if (validArticles.isEmpty) {
      validArticles = List.generate(
        5,
        (index) => NewsArticle(
          title: 'No Title',
          description: '',
          urlToImage: '',
          url: '',
        ),
      );
    }

    return Container(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: validArticles.map((article) => _buildNewsCard(article)).toList(),
      ),
    );
  }

  Widget _buildNewsCard(NewsArticle article) {
    final bool hasValidUrl = Uri.tryParse(article.urlToImage)?.hasAbsolutePath ?? false;
    final String imageUrl = hasValidUrl ? article.urlToImage : 'https://via.placeholder.com/150';

    return Container(
      width: 300,
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              height: 150,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Center(
                  child: Text('Image not available', style: TextStyle(color: Colors.grey)),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    article.description,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({required String text, required int index}) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) {
        bool isSelected = _tabController.index == index;
        return GestureDetector(
          onTap: () {
            _tabController.animateTo(index);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            constraints: BoxConstraints(minWidth: 60),
            child: Text(
              text,
              style: TextStyle(
                fontSize: isSelected ? 18 : 16,
                color: isSelected ? Colors.black : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List<PostModel>> fetchPosts() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.userId;
      final userSubscriptions = userProvider.subscriptions;

      QuerySnapshot querySnapshot;

      if (currentCategory == 'All') {
        querySnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .where('authorId', whereIn: [userId, ...userSubscriptions])
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .where('category', isEqualTo: currentCategory)
            .get();
      }

      return querySnapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
    } catch (e) {
      print('Error fetching posts: $e');
      throw Exception('Error fetching posts');
    }
  }

  Future<List<NewsArticle>> fetchNews() async {
    final apiKey = '93fdbf4644504e8d8f62632fa23f6a95';
    final keywords = [
      'young people',
      'youth development',
      'sport',
      'education',
      'grants',
      'scholarships',
      'music',
      'culture',
      'intelligence'
    ];
    final query = keywords.join(' OR ');
    final url = 'https://newsapi.org/v2/everything?q=($query)&sortBy=publishedAt&apiKey=$apiKey';
    print('Fetching news from: $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      final Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> articlesData = jsonData['articles'];
      List<NewsArticle> articles = articlesData
          .map((data) => NewsArticle.fromJson(data))
          .where((article) => !containsProhibitedContent(article))
          .toList();
      return articles;
    } else {
      print('Failed to load news: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load news');
    }
  }

  bool containsProhibitedContent(NewsArticle article) {
    final prohibitedWords = ['sex', 'abuse'];
    final content = '${article.title} ${article.description}'.toLowerCase();
    for (var word in prohibitedWords) {
      if (content.contains(word)) {
        return true;
      }
    }
    return false;
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.backgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}