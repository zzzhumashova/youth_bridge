import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String authorId;
  final List<String> mediaUrls;
  final String description;
  final Timestamp timestamp;

  PostModel({
    required this.authorId,
    required this.mediaUrls,
    required this.description,
    required this.timestamp,
  });

  factory PostModel.fromDocument(DocumentSnapshot doc) {
    return PostModel(
      authorId: doc['authorId'],
      mediaUrls: List<String>.from(doc['mediaUrls']),
      description: doc['description'],
      timestamp: doc['timestamp'],
    );
  }
}
