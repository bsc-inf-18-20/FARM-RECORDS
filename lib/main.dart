import 'package:farmrecord/pages/home/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmrecord/pages/log_in.dart';
import 'package:farmrecord/pages/home/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Management',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home:
          const AuthenticationWrapper(), // Use AuthenticationWrapper for initial screen
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in, show HomePage
          return HomePage(
            user: snapshot.data!,
            appTheme: AppTheme(),
          );
        } else {
          // No user logged in, show LoginPage
          return const LoginPage();
        }
      },
    );
  }
}
