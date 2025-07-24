// lib/screens/quote_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:wellness/services/firestore_service.dart'; // Import FirestoreService
import 'package:wellness/models/quote.dart'; // Import the Quote model

class QuoteDetailScreen extends StatelessWidget {
  final Quote quote; // Using the imported Quote model directly
  const QuoteDetailScreen({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.format_quote,
              size: 80,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 30),
            Text(
              '"${quote.text}"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '- ${quote.author}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () async {
                // Add to favorites
                await FirestoreService().addFavorite(quote.id, 'quote');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quote added to favorites!')),
                );
              },
              icon: const Icon(Icons.favorite_border),
              label: const Text('Add to Favorites'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
