import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth auth;
  late StreamSubscription<User?> _authStateChangesSubscription;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final storage = FlutterSecureStorage();
  final bool rememberMeValue;

  AuthProvider({
    required this.auth,
    required this.emailController,
    required this.passwordController,
    required this.rememberMeValue,
  }) {
    _authStateChangesSubscription = auth.authStateChanges().listen(userChanges);
  }

  User? _user;

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    emailController.text = '';
    passwordController.text = '';
    notifyListeners();
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    final userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    _user = userCredential.user;
    notifyListeners();
    return userCredential;
  }

  Future<void> signOut() async {
    await auth.signOut();
    _user = null;
    clearUser();
    await clearCredentials();
    notifyListeners();
  }

  void userChanges(User? user) {
    if (user != null) {
      setUser(user);
    } else {
      clearUser();
    }
  }

  Future<void> clearCredentials() async {
    await storage.delete(key: 'email');
    await storage.delete(key: 'password');
  }

  @override
  void dispose() {
    _authStateChangesSubscription.cancel();
    super.dispose();
  }
}
