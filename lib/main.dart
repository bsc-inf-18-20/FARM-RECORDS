// import 'package:farmrecord/pages/log_in.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:studie/pages/Login_Page.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final _firstNameController = TextEditingController();
//   final _surnameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _isLoading = false;

//   Future<void> _signUp() async {
//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Passwords do not match')),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Account created successfully. Please log in.'),
//         ),
//       );

//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//       );
//     } on FirebaseAuthException catch (e) {
//       String message = 'An error occurred, please try again';
//       if (e.code == 'email-already-in-use') {
//         message = 'The account already exists for that email.';
//       } else if (e.code == 'weak-password') {
//         message = 'The password provided is too weak.';
//       }
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(message)));
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Create New Account',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: const Color.fromARGB(255, 44, 133, 8),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Card(
//             elevation: 8,
//             color: Colors.white.withOpacity(0.9),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'Create an Account',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Color.fromARGB(255, 44, 133, 8),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _firstNameController,
//                     decoration: const InputDecoration(
//                       labelText: 'First Name',
//                       prefixIcon: Icon(Icons.person),
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: _surnameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Surname',
//                       prefixIcon: Icon(Icons.person_outline),
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: _emailController,
//                     decoration: const InputDecoration(
//                       labelText: 'Email',
//                       prefixIcon: Icon(Icons.email),
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                       labelText: 'Password',
//                       prefixIcon: Icon(Icons.lock),
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: _confirmPasswordController,
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                       labelText: 'Confirm Password',
//                       prefixIcon: Icon(Icons.lock_outline),
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   _isLoading
//                       ? const CircularProgressIndicator()
//                       : ElevatedButton(
//                           onPressed: _signUp,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 const Color.fromARGB(255, 44, 133, 8),
//                             padding: const EdgeInsets.symmetric(horizontal: 50),
//                           ),
//                           child: const Text(
//                             'Sign Up',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                   const SizedBox(height: 10),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => const LoginPage(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       'Already have an account? Log in.',
//                       style: TextStyle(color: Colors.deepPurple),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _surnameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:farmrecord/pages/log_in.dart';
// import 'package:farmrecord/pages/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: const LoginPage(), // Set LoginPage as the initial screen
    );
  }
}
