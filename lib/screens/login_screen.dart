// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For FirebaseAuthException
import 'package:wellness/services/auth_service.dart'; // Import your AuthService
import 'package:wellness/screens/sign_up_screen.dart';
import 'package:wellness/screens/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // Instance of AuthService
  bool _isLoading = false; // To show loading indicator during async operations

  // Function to handle user login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) { // Validate all form fields
      setState(() {
        _isLoading = true; // Show loading indicator
      });
      try {
        await _authService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        // On successful login, AuthWrapper will automatically navigate to DashboardScreen
      } on FirebaseAuthException catch (e) {
        // Handle specific Firebase authentication errors
        String message = 'An unknown error occurred.';
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided for that user.';
        } else if (e.code == 'invalid-email') {
          message = 'The email address is not valid.';
        } else if (e.code == 'network-request-failed') {
          message = 'Network error. Please check your internet connection.';
        }
        // Show error message using a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  // Optional: Function to handle Google Sign-In
  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _authService.signInWithGoogle();
      // AuthWrapper will handle navigation
    } on FirebaseAuthException catch (e) {
      String message = 'Google Sign-In failed.';
      if (e.code == 'account-exists-with-different-credential') {
        message = 'An account already exists with the same email address but different sign-in credentials.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sign-In failed or was cancelled.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView( // Allows scrolling if content overflows
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, // Assign the form key
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email input field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16), // Spacer
                // Password input field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Hide password text
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Login button or loading indicator
                _isLoading
                    ? const CircularProgressIndicator() // Show loading spinner
                    : ElevatedButton(
                  onPressed: _login, // Call login function on press
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // Full width button
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),
                // Button to navigate to Sign Up screen
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text("Don't have an account? Sign Up"),
                ),
                // Button to navigate to Forgot Password screen
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen()),
                    );
                  },
                  child: const Text("Forgot Password?"),
                ),
                const SizedBox(height: 24),
                // Optional: Google Sign-In Button
                // ElevatedButton.icon(
                //   onPressed: _loginWithGoogle,
                //   icon: Image.asset('assets/google_logo.png', height: 24.0), // You need to add a google_logo.png in assets folder
                //   label: const Text('Sign in with Google'),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.white,
                //     foregroundColor: Colors.black87,
                //     minimumSize: const Size(double.infinity, 50),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
