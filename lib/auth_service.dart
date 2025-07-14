// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to listen to authentication state changes
  // This will emit a User object if logged in, or null if logged out.
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // 1. Email and Password Sign Up
  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Re-throw the exception to be caught and handled in the UI
      rethrow;
    } catch (e) {
      print('Sign Up Error: $e');
      return null;
    }
  }

  // 2. Email and Password Login
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Re-throw the exception to be caught and handled in the UI
      rethrow;
    } catch (e) {
      print('Sign In Error: $e');
      return null;
    }
  }

  // 3. Forgot Password / Send Password Reset Email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      // Re-throw the exception to be caught and handled in the UI
      rethrow;
    } catch (e) {
      print('Send Password Reset Email Error: $e');
    }
  }

  // 4. Change Password (requires re-authentication if session is old)
  Future<void> changePassword(String currentPassword, String newPassword) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently logged in.');
    }

    try {
      // Re-authenticate the user first for security
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!, // Assuming email is available and user signed in with email
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update the password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      // Re-throw the exception to be caught and handled in the UI
      rethrow;
    } catch (e) {
      print('Change Password Error: $e');
    }
  }

  // 5. Logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // Also sign out from Google if the user signed in with Google
      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSignIn().signOut();
      }
    } catch (e) {
      print('Sign Out Error: $e');
    }
  }

  // Optional: Google Sign-In (as per previous discussion)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // If user cancelled, googleUser will be null
      if (googleUser == null) {
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // Re-throw the exception to be caught and handled in the UI
      rethrow;
    } catch (e) {
      print("Google authentication error: $e");
      return null;
    }
  }
}
