// lib/services/firestore_service.dart (WITH DEBUG PRINTS)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import the new model files
import 'package:wellness/models/user_preference.dart';
import 'package:wellness/models/category.dart';
import 'package:wellness/models/preference.dart';
import 'package:wellness/models/tip.dart';
import 'package:wellness/models/quote.dart';
import 'package:wellness/models/favorite.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // --- Firestore Operations ---

  // User Preferences
  Future<void> saveUserPreferences(List<String> preferenceIds) async {
    if (currentUserId == null) return;
    await _db.collection('userPreferences').doc(currentUserId).set({
      'userId': currentUserId,
      'preferenceIds': preferenceIds,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<UserPreference?> getUserPreferencesStream() {
    if (currentUserId == null) return Stream.value(null);
    return _db.collection('userPreferences').doc(currentUserId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserPreference.fromFirestore(snapshot);
      }
      return null;
    });
  }

  Future<UserPreference?> getUserPreferencesOnce() async {
    if (currentUserId == null) return null;
    DocumentSnapshot doc = await _db.collection('userPreferences').doc(currentUserId).get();
    if (doc.exists) {
      return UserPreference.fromFirestore(doc);
    }
    return null;
  }

  // Categories
  Stream<List<Category>> getCategoriesStream() {
    return _db.collection('categories').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    });
  }

  Future<void> addCategory(String name) async {
    await _db.collection('categories').add({'name': name, 'timestamp': FieldValue.serverTimestamp()});
  }

  // Preferences
  Stream<List<Preference>> getPreferencesStream(String categoryId) {
    return _db.collection('preferences').where('categoryId', isEqualTo: categoryId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Preference.fromFirestore(doc)).toList();
    });
  }

  Stream<List<Preference>> getAllPreferencesStream() {
    return _db.collection('preferences').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Preference.fromFirestore(doc)).toList();
    });
  }

  Future<void> addPreference(String categoryId, String name) async {
    await _db.collection('preferences').add({
      'categoryId': categoryId,
      'name': name,
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  // Tips
  Stream<List<Tip>> getTipsByPreferenceStream(List<String> preferenceIds) {
    if (preferenceIds.isEmpty) return Stream.value([]);
    if (preferenceIds.length > 10) {
      print("Warning: Querying more than 10 preferences at once for tips. Firestore 'in' query limit is 10.");
      preferenceIds = preferenceIds.sublist(0, 10);
    }
    return _db.collection('tips').where('preferenceId', whereIn: preferenceIds).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Tip.fromFirestore(doc)).toList();
    });
  }

  Future<void> addTip(String preferenceId, String title, String description) async {
    await _db.collection('tips').add({
      'preferenceId': preferenceId,
      'title': title,
      'description': description,
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  // Quotes
  Stream<List<Quote>> getQuotesByCategoryStream(List<String> categoryIds) {
    if (categoryIds.isEmpty) return Stream.value([]);
    if (categoryIds.length > 10) {
      print("Warning: Querying more than 10 categories at once for quotes. Firestore 'in' query limit is 10.");
      categoryIds = categoryIds.sublist(0, 10);
    }
    return _db.collection('quotes').where('categoryId', whereIn: categoryIds).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Quote.fromFirestore(doc)).toList();
    });
  }

  Future<void> addQuote(String categoryId, String author, String text) async {
    await _db.collection('quotes').add({
      'categoryId': categoryId,
      'author': author,
      'text': text,
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  // Favorites
  Future<void> addFavorite(String contentId, String contentType) async {
    if (currentUserId == null) return;
    final existingFavorite = await _db.collection('favoritePreferences')
        .where('userId', isEqualTo: currentUserId)
        .where('contentId', isEqualTo: contentId)
        .limit(1)
        .get();

    if (existingFavorite.docs.isEmpty) {
      await _db.collection('favoritePreferences').add({
        'userId': currentUserId,
        'contentId': contentId,
        'contentType': contentType,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      print('Content already favorited by this user.');
    }
  }

  Future<void> removeFavorite(String contentId) async {
    if (currentUserId == null) return;
    final querySnapshot = await _db.collection('favoritePreferences')
        .where('userId', isEqualTo: currentUserId)
        .where('contentId', isEqualTo: contentId)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Stream<List<Favorite>> getFavoritesStream() {
    if (currentUserId == null) return Stream.value([]);
    return _db.collection('favoritePreferences')
        .where('userId', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Favorite.fromFirestore(doc)).toList();
    });
  }

  Future<Tip?> getTipById(String tipId) async {
    DocumentSnapshot doc = await _db.collection('tips').doc(tipId).get();
    return doc.exists ? Tip.fromFirestore(doc) : null;
  }

  Future<Quote?> getQuoteById(String quoteId) async {
    DocumentSnapshot doc = await _db.collection('quotes').doc(quoteId).get();
    return doc.exists ? Quote.fromFirestore(doc) : null;
  }

  // User Management (for userRole)
  Future<void> createUserProfile(String userId, String email, String name, String userRole) async {
    print('FirestoreService: Attempting to create user profile for UID: $userId'); // Debug print
    try {
      await _db.collection('users').doc(userId).set({
        'email': email,
        'name': name,
        'userRole': userRole,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print('FirestoreService: User profile created successfully for UID: $userId'); // Debug print
    } catch (e) {
      print('FirestoreService: ERROR creating user profile for UID: $userId - $e'); // Debug print
      rethrow; // Re-throw to propagate the error if necessary
    }
  }

  Future<String?> getUserRole(String userId) async {
    DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
    if (doc.exists) {
      return (doc.data() as Map<String, dynamic>)['userRole'];
    }
    return null;
  }

  Stream<String?> getUserRoleStream(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return (snapshot.data() as Map<String, dynamic>)['userRole'];
      }
      return null;
    });
  }
}
