// lib/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Required for User type
import 'package:wellness/auth_service.dart'; // Import your AuthService
import 'package:wellness/login_screen.dart'; // Import your LoginScreen
import 'package:wellness/dashboard_screen.dart'; // Import your DashboardScreen

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Use StreamBuilder to listen to authentication state changes from AuthService
    return StreamBuilder<User?>(
      stream: AuthService().user, // Access the user stream from AuthService
      builder: (context, snapshot) {
        // Show a loading indicator while the connection state is waiting
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        // If there is data in the snapshot (meaning a user is logged in)
        else if (snapshot.hasData) {
          // Navigate to the DashboardScreen
          return const DashboardScreen(dashboardViewModel: null,);
        }
        // If there is no data (meaning no user is logged in)
        else {
          // Navigate to the LoginScreen
          return const LoginScreen();
        }
      },
    );
  }
}
