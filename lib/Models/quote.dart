// lib/models/quote.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Quote {
  final String id;
  final String categoryId; // Or preferenceId, depending on how granular you link them
  final String author;
  final String text;

  Quote({required this.id, required this.categoryId, required this.author, required this.text});

  factory Quote.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Quote(
      id: doc.id,
      categoryId: data['categoryId'] ?? '',
      author: data['author'] ?? '',
      text: data['text'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'categoryId': categoryId,
      'author': author,
      'text': text,
    };
  }
}
