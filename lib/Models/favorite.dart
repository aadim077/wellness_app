// lib/models/favorite.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  final String id;
  final String userId;
  final String contentId; // ID of the quote or tip
  final String contentType; // 'quote' or 'tip'

  Favorite({required this.id, required this.userId, required this.contentId, required this.contentType});

  factory Favorite.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Favorite(
      id: doc.id,
      userId: data['userId'] ?? '',
      contentId: data['contentId'] ?? '',
      contentType: data['contentType'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'contentId': contentId,
      'contentType': contentType,
    };
  }
}
