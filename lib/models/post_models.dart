class PostsModel {
  final String username;
  final String city;
  final String avatarUrl;
  final String? photoUrl;
  final String description;

  PostsModel({
    required this.username,
    required this.city,
    required this.avatarUrl,
    this.photoUrl,
    required this.description,
  });

  factory PostsModel.fromFirestore(Map<String, dynamic> firestore) {
    return PostsModel(
      username: firestore['username'],
      city: firestore['city'],
      avatarUrl: firestore['avatarUrl'],
      photoUrl: firestore['photoUrl'],
      description: firestore['description'],
    );
  }
}
