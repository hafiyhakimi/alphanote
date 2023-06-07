import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'authprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = FlutterSecureStorage();
  bool rememberMeValue = false;

  // Future<List<String>> _getEmailAndPasswordFromStorage() async {
  //   final email = await storage.read(key: 'email');
  //   final password = await storage.read(key: 'password');
  //   return [email ?? '', password ?? ''];
  // }

  @override
  void initState() {
    super.initState();
    _emailController.text = '';
    _passwordController.text = '';
    // _getEmailAndPasswordFromStorage().then((values) {
    //   _emailController.text = values[0];
    //   _passwordController.text = values[1];
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: rememberMeValue,
                  onChanged: (value) {
                    setState(() {
                      rememberMeValue = value!;
                    });
                  },
                ),
                Text('Remember me'),
              ],
            ),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return ElevatedButton(
                  onPressed: () async {
                    try {
                      await authProvider.signInWithEmail(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
                        print('Invalid email or password');
                      }
                    }
                  },
                  child: Text('Sign In'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
