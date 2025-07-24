// lib/services/auth_service.dart (WITH DEBUG PRINTS)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wellness/services/firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  String? get currentUserId => _auth.currentUser?.uid;

  // 1. Email and Password Sign Up
  Future<UserCredential?> signUpWithEmail(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('AuthService: User signed up with email: ${userCredential.user?.email}');

      if (userCredential.user != null) {
        print('AuthService: User object is NOT null. Attempting to create Firestore profile...');
        await _firestoreService.createUserProfile(
          userCredential.user!.uid,
          email,
          name,
          'customer',
        );
        print('AuthService: createUserProfile call completed.');
      } else {
        print('AuthService: User object IS null after sign up. Profile not created.');
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('AuthService: FirebaseAuthException during sign up: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('AuthService: Generic Sign Up Error: $e');
      return null;
    }
  }

  // 2. Email and Password Login (no change needed here for Firestore)
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      print('Sign In Error: $e');
      return null;
    }
  }

  // 3. Forgot Password / Send Password Reset Email (no change needed)
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      print('Send Password Reset Email Error: $e');
    }
  }

  // 4. Change Password (no change needed)
  Future<void> changePassword(String currentPassword, String newPassword) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently logged in.');
    }

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      print('Change Password Error: $e');
    }
  }

  // 5. Logout (no change needed)
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSignIn().signOut();
      }
    } catch (e) {
      print('Sign Out Error: $e');
    }
  }

  // Optional: Google Sign-In (updated to create user profile)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print('AuthService: Google sign-in cancelled.');
        return null;
      }
      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      print('AuthService: User signed in with Google: ${userCredential.user?.email}');
      if (userCredential.user != null && userCredential.user!.displayName != null) {
        print('AuthService: User object is NOT null. Attempting to create Firestore profile for Google user...');
        await _firestoreService.createUserProfile(
          userCredential.user!.uid,
          userCredential.user!.email ?? '',
          userCredential.user!.displayName!,
          'customer',
        );
        print('AuthService: createUserProfile call completed for Google user.');
      } else {
        print('AuthService: User object IS null after Google sign-in. Profile not created.');
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('AuthService: FirebaseAuthException during Google sign-in: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print("AuthService: Generic Google authentication error: $e");
      return null;
    }
  }
}
