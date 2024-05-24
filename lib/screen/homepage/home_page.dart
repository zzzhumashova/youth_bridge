import 'package:flutter/material.dart';
import 'package:youth_bridge/screen/homepage/posts/posts_category.dart';
import 'package:youth_bridge/screen/homepage/search_page.dart';
import 'package:youth_bridge/widgets/themes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<NewsArticle>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _newsFuture = fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text("Youth Bridge"),
      ),
      body: Column(
        children: [
          Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
          FutureBuilder<List<NewsArticle>>(
            future: _newsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(color: AppColors.primaryColor,);
              } else if (snapshot.hasError) {
                print('Error: ${snapshot.error}'); // Логирование ошибки
                return _buildNewsFeed([]);
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                print('No news available'); // Логирование отсутствия данных
                return _buildNewsFeed([]);
              } else {
                final newsArticles = snapshot.data!;
                return _buildNewsFeed(newsArticles);
              }
            },
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              tabs: [
                _buildTab(text: 'All', index: 0),
                _buildTab(text: 'Sport', index: 1),
                _buildTab(text: 'Education', index: 2),
                _buildTab(text: 'Grants', index: 3),
                _buildTab(text: 'Volunteering', index: 4),
                _buildTab(text: 'Travel', index: 5),
                _buildTab(text: 'Science', index: 6),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                PostsCategoryWidget(category: 'All'),
                PostsCategoryWidget(category: 'Sport'),
                PostsCategoryWidget(category: 'Education'),
                PostsCategoryWidget(category: 'Grants'),
                PostsCategoryWidget(category: 'Volunteering'),
                PostsCategoryWidget(category: 'Travel'),
                PostsCategoryWidget(category: 'Science'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsFeed(List<NewsArticle> newsArticles) {
    if (newsArticles.isEmpty) {
      newsArticles = List.generate(5, (index) => NewsArticle(
        title: 'No Title',
        description: '',
        urlToImage: '',
        url: '',
      ));
    }

    return Container(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: newsArticles.map((article) => _buildNewsCard(article)).toList(),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl,
              height: 150,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
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
    );
  }

  Widget _buildTab({required String text, required int index}) {
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        constraints: BoxConstraints(minWidth: 60),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold),
          ),
        ),
      );
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
    final prohibitedWords = ['sex', 'abuse']; // Add prohibited words here
    final content = '${article.title} ${article.description}'.toLowerCase();
    for (var word in prohibitedWords) {
      if (content.contains(word)) {
        return true;
      }
    }
    return false;
  }
}

class NewsArticle {
  final String title;
  final String description;
  final String urlToImage;
  final String url;

  NewsArticle({required this.title, required this.description, required this.urlToImage, required this.url});

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final NewsArticle article;

  NewsDetailPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            article.urlToImage.isNotEmpty
                ? Image.network(article.urlToImage)
                : Container(),
            SizedBox(height: 10),
            Text(
              article.description, 
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
  
