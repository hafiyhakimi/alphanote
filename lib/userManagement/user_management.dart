import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManagement {
  // Create a new user with email and password
  static Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Create a new user with email and password
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    return userCredential.user;
  }

  // Sign in with email and password
  static Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Sign in with email and password
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return userCredential.user;
  }

  // Sign out the current user
  static Future<void> signOut() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Sign out the current user
    return FirebaseAuth.instance.signOut();
  }

  // Get the current user
  static Future<User?> getCurrentUser() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Get the current user
    return FirebaseAuth.instance.currentUser;
  }

  // Check if the user is signed in
  static Future<bool> isSignedIn() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Check if the user is signed in
    return FirebaseAuth.instance.currentUser != null;
  }
}
