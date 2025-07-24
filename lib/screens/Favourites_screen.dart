// lib/screens/favorites_screen.dart (CORRECTED)
import 'package:flutter/material.dart';
import 'package:wellness/services/firestore_service.dart';
// Import the data models
import 'package:wellness/models/favorite.dart';
import 'package:wellness/models/quote.dart';
import 'package:wellness/models/tip.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  // Function to remove a favorite item from Firestore
  Future<void> _removeFavorite(String contentId) async {
    try {
      await _firestoreService.removeFavorite(contentId);
      // Show a confirmation message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from favorites.')),
      );
    } catch (e) {
      // Show an error message if removal fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove favorite: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: StreamBuilder<List<Favorite>>( // Corrected: Using Favorite directly
        // Listen to the stream of favorite items for the current user
        stream: _firestoreService.getFavoritesStream(),
        builder: (context, snapshot) {
          // Show a loading indicator while data is being fetched
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Display an error message if something went wrong
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Display a message if there are no favorites
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('You have no favorites yet. Tap the heart icon on quotes/tips to add them!'));
          }

          // If data is available, display the list of favorites
          final favorites = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              // Use FutureBuilder to fetch the actual content (quote or tip) details
              // based on the contentId and contentType stored in the Favorite object.
              return FutureBuilder<dynamic>( // dynamic because it can return a Quote or a Tip object
                future: favorite.contentType == 'quote'
                    ? _firestoreService.getQuoteById(favorite.contentId)
                    : _firestoreService.getTipById(favorite.contentId),
                builder: (context, contentSnapshot) {
                  // Show a small loading indicator for each content item
                  if (contentSnapshot.connectionState == ConnectionState.waiting) {
                    return const Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text('Loading favorite...'),
                        trailing: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  // Handle errors when fetching content details
                  if (contentSnapshot.hasError) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text('Error loading content: ${contentSnapshot.error}'),
                      ),
                    );
                  }
                  // Handle cases where content might have been deleted from its original collection
                  if (!contentSnapshot.hasData) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text('Content not found (ID: ${favorite.contentId}). It might have been removed.'),
                      ),
                    );
                  }

                  // Display the content based on its type
                  if (favorite.contentType == 'quote') {
                    final quote = contentSnapshot.data as Quote; // Corrected: Using Quote directly
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: const Icon(Icons.format_quote, color: Colors.blueAccent),
                        title: Text('"${quote.text}"'),
                        subtitle: Text('- ${quote.author}'),
                        // Button to remove from favorites
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () => _removeFavorite(favorite.contentId),
                        ),
                        onTap: () {
                          // Optional: Navigate to a detail screen for the quote
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => QuoteDetailScreen(quote: quote),
                          // ));
                        },
                      ),
                    );
                  } else if (favorite.contentType == 'tip') {
                    final tip = contentSnapshot.data as Tip; // Corrected: Using Tip directly
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: const Icon(Icons.health_and_safety, color: Colors.greenAccent),
                        title: Text(tip.title),
                        subtitle: Text(tip.description),
                        // Button to remove from favorites
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () => _removeFavorite(favorite.contentId),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink(); // Fallback, should not be reached
                },
              );
            },
          );
        },
      ),
    );
  }
}
