// lib/models/preference.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Preference {
  final String id;
  final String categoryId;
  final String name;

  Preference({required this.id, required this.categoryId, required this.name});

  factory Preference.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Preference(
      id: doc.id,
      categoryId: data['categoryId'] ?? '',
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'categoryId': categoryId,
      'name': name,
    };
  }
}
