import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youth_bridge/widgets/themes.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  List<DocumentSnapshot> _userResults = [];
  List<DocumentSnapshot> _postResults = [];
  List<DocumentSnapshot> _eventResults = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchFocusNode.requestFocus();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });
    if (_isSearching) {
      _performSearch(query);
    } else {
      setState(() {
        _userResults = [];
        _postResults = [];
        _eventResults = [];
      });
    }
  }

  Future<void> _performSearch(String query) async {
    final userQuery = FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff');
    final postQuery = FirebaseFirestore.instance
        .collection('posts')
        .where('description', isGreaterThanOrEqualTo: query)
        .where('description', isLessThanOrEqualTo: query + '\uf8ff');
    final eventQuery = FirebaseFirestore.instance
        .collection('event collection')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + '\uf8ff');

    final userResults = await userQuery.get();
    final postResults = await postQuery.get();
    final eventResults = await eventQuery.get();

    setState(() {
      _userResults = userResults.docs;
      _postResults = postResults.docs;
      _eventResults = eventResults.docs;
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 30,),
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
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
            if (_isSearching)
              TabBar(
                controller: _tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.black, width: 2.0), // Change the color and thickness of the underline
                ),
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 18, color: Colors.black54),
                tabs: [
                  Tab(text: 'Users'),
                  Tab(text: 'Posts'),
                  Tab(text: 'Events'),
                ],
              ),
            Expanded(
              child: _isSearching
                  ? TabBarView(
                      controller: _tabController,
                      children: [
                        _buildResultsList(_userResults, 'name'),
                        _buildResultsList(_postResults, 'title'),
                        _buildResultsList(_eventResults, 'title'),
                      ],
                    )
                  : GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(22, (index) {
                        return Container(
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(List<DocumentSnapshot> results, String field) {
    if (results.isEmpty) {
      return Center(
        child: Text('No results found'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index].data() as Map<String, dynamic>;
        return ListTile(
          title: Text(result[field] ?? 'No title'),
          subtitle: Text(result['description'] ?? ''),
        );
      },
    );
  }
}
