// lib/models/tip.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Tip {
  final String id;
  final String preferenceId;
  final String title;
  final String description;

  Tip({required this.id, required this.preferenceId, required this.title, required this.description});

  factory Tip.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Tip(
      id: doc.id,
      preferenceId: data['preferenceId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'preferenceId': preferenceId,
      'title': title,
      'description': description,
    };
  }
}
