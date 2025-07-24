// lib/models/user_preference.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPreference {
  final String id; // Document ID, or user ID
  final String userId;
  final List<String> preferenceIds; // List of preference IDs selected by user

  UserPreference({required this.id, required this.userId, required this.preferenceIds});

  factory UserPreference.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserPreference(
      id: doc.id,
      userId: data['userId'] ?? '',
      preferenceIds: List<String>.from(data['preferenceIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'preferenceIds': preferenceIds,
    };
  }
}
