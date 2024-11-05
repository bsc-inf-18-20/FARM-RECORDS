import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmrecord/pages/log_in.dart';
import 'package:farmrecord/pages/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(); // Initialize Firebase
    print("Firebase initialized successfully.");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmRecord App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home:
          const AuthenticationWrapper(), // Use AuthenticationWrapper to determine the initial screen
    );
  }
}

// Wrapper widget to handle user authentication state and initial screen
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

        // Log the authentication state
        print("Auth state: ${snapshot.hasData ? 'Logged In' : 'Logged Out'}");

        // Check if the user is logged in (snapshot has data)
        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in, navigate to HomePage
          return HomePage(user: snapshot.data!);
        } else {
          // User is not logged in, show LoginPage
          return const LoginPage();
        }
      },
    );
  }
}
