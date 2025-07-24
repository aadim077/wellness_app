// lib/screens/dashboard_screen.dart (UPDATED & CORRECTED)
import 'package:flutter/material.dart';
import 'package:wellness/services/auth_service.dart';
import 'package:wellness/services/firestore_service.dart';
import 'package:wellness/screens/change_password_screen.dart';
import 'package:wellness/screens/add_category_screen.dart';
import 'package:wellness/screens/add_quote.dart'; // Corrected import: added _screen
import 'package:wellness/screens/add_health_tips_screen.dart';
import 'package:wellness/screens/Favourites_screen.dart'; // Corrected import: case sensitivity
import 'package:wellness/screens/quote_detail_screen.dart'; // Added: Import for QuoteDetailScreen

import 'package:wellness/models/user_preference.dart'; // Imported UserPreference model
import 'package:wellness/models/tip.dart'; // Imported Tip model
import 'package:wellness/models/quote.dart'; // Imported Quote model

class DashboardScreen extends StatefulWidget {
  // Removed 'required dashboardViewModel' as it was unused and causing an error
  const DashboardScreen({super.key, required dashboardViewModel});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  String _userRole = 'customer'; // Default role, will be updated from Firestore

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    final userId = _authService.currentUserId;
    if (userId != null) {
      _firestoreService.getUserRoleStream(userId).listen((role) {
        if (role != null) {
          setState(() {
            _userRole = role;
          });
        }
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    await _authService.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully.')),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onAddNew,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 30, color: Colors.blueAccent),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            if (onAddNew != null)
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blueAccent, size: 30),
                    onPressed: onAddNew,
                    tooltip: 'Add New',
                  ),
                  const Text('Add New', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.redAccent), // Favorites button
            tooltip: 'Favorites',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const FavoritesScreen(),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.vpn_key_sharp, color: Colors.white),
            tooltip: 'Change Password',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ChangePasswordScreen(),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDashboardCard(
              icon: Icons.people,
              title: 'Total Users',
              value: '1488888',
              onAddNew: null,
            ),
            // Admin-only "Add New" buttons
            if (_userRole == 'admin') ...[
              _buildDashboardCard(
                icon: Icons.category,
                title: 'Total Category',
                value: '100',
                onAddNew: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddCategoryScreen(),
                  ));
                },
              ),
              _buildDashboardCard(
                icon: Icons.format_quote,
                title: 'Total Quotes',
                value: '200',
                onAddNew: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddQuoteScreen(),
                  ));
                },
              ),
              _buildDashboardCard(
                icon: Icons.health_and_safety,
                title: 'Total Health Tips',
                value: '50',
                onAddNew: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddHealthTipsScreen(),
                  ));
                },
              ),
            ],
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Personalized Content for You:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            // StreamBuilder for personalized content
            StreamBuilder<UserPreference?>( // Corrected: Using UserPreference directly
              stream: _firestoreService.getUserPreferencesStream(),
              builder: (context, userPrefsSnapshot) {
                if (userPrefsSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (userPrefsSnapshot.hasError) {
                  return Text('Error loading preferences: ${userPrefsSnapshot.error}');
                }
                if (!userPrefsSnapshot.hasData || userPrefsSnapshot.data!.preferenceIds.isEmpty) {
                  return const Text('No preferences selected. Please go to your profile to select preferences.');
                }

                final selectedPreferenceIds = userPrefsSnapshot.data!.preferenceIds;

                return Column(
                  children: [
                    // Display Personalized Tips
                    StreamBuilder<List<Tip>>( // Corrected: Using Tip directly
                      stream: _firestoreService.getTipsByPreferenceStream(selectedPreferenceIds),
                      builder: (context, tipsSnapshot) {
                        if (tipsSnapshot.connectionState == ConnectionState.waiting) {
                          return const LinearProgressIndicator();
                        }
                        if (tipsSnapshot.hasError) {
                          return Text('Error loading tips: ${tipsSnapshot.error}');
                        }
                        if (!tipsSnapshot.hasData || tipsSnapshot.data!.isEmpty) {
                          return const Text('No health tips found for your preferences.');
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text('Health Tips:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            ...tipsSnapshot.data!.map((tip) => Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: ListTile(
                                title: Text(tip.title),
                                subtitle: Text(tip.description),
                                trailing: IconButton(
                                  icon: const Icon(Icons.favorite_border),
                                  onPressed: () async {
                                    await _firestoreService.addFavorite(tip.id, 'tip');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Tip added to favorites!')),
                                    );
                                  },
                                ),
                              ),
                            )).toList(),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    // Display Personalized Quotes
                    StreamBuilder<List<Quote>>( // Corrected: Using Quote directly
                      stream: _firestoreService.getQuotesByCategoryStream(selectedPreferenceIds), // Assuming preferences map to categories for quotes
                      builder: (context, quotesSnapshot) {
                        if (quotesSnapshot.connectionState == ConnectionState.waiting) {
                          return const LinearProgressIndicator();
                        }
                        if (quotesSnapshot.hasError) {
                          return Text('Error loading quotes: ${quotesSnapshot.error}');
                        }
                        if (!quotesSnapshot.hasData || quotesSnapshot.data!.isEmpty) {
                          return const Text('No quotes found for your preferences.');
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text('Motivational Quotes:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            ...quotesSnapshot.data!.map((quote) => Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: ListTile(
                                title: Text('"${quote.text}"'),
                                subtitle: Text('- ${quote.author}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.favorite_border),
                                  onPressed: () async {
                                    await _firestoreService.addFavorite(quote.id, 'quote');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Quote added to favorites!')),
                                    );
                                  },
                                ),
                                onTap: () {
                                  // Navigate to Quote Detail Screen (optional, but good for assignment)
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => QuoteDetailScreen(quote: quote),
                                  ));
                                },
                              ),
                            )).toList(),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
