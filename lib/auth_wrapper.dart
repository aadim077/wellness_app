// lib/auth_wrapper.dart (UPDATED - Corrected for Preference Flow)
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellness/services/auth_service.dart'; // Ensure this uses 'wellness' package name
import 'package:wellness/services/firestore_service.dart'; // Import FirestoreService
import 'package:wellness/screens/login_screen.dart';
import 'package:wellness/screens/dashboard_screen.dart';
import 'package:wellness/screens/preference_selection_screen.dart'; // Import new screen
import 'package:wellness/models/user_preference.dart'; // Import UserPreference model

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().user,
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (authSnapshot.hasData) {
          // User is signed in
          final String? userId = authSnapshot.data!.uid;
          if (userId == null) {
            // This case should ideally not happen if authSnapshot.hasData is true
            return const LoginScreen();
          }

          // Check if user has selected preferences from Firestore
          return StreamBuilder<UserPreference?>( // Using UserPreference model directly
            stream: FirestoreService().getUserPreferencesStream(),
            builder: (context, preferenceSnapshot) {
              if (preferenceSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              } else if (preferenceSnapshot.hasData && preferenceSnapshot.data!.preferenceIds.isNotEmpty) {
                // User is signed in AND has preferences saved
                return const DashboardScreen(dashboardViewModel: null,);
              } else {
                // User is signed in but HAS NOT selected preferences yet
                // Or preference data is empty/null
                return const PreferenceSelectionScreen();
              }
            },
          );
        } else {
          // User is signed out
          return const LoginScreen();
        }
      },
    );
  }
}
