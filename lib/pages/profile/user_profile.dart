import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'delete_account.dart'; // Import your delete account logic
import 'logout.dart'; // Import your logout logic

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // User Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.teal,
                    child: Text(
                      user?.email != null
                          ? user!.email!.substring(0, 1).toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.email ?? 'No Email Available',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Options Section
            Column(
              children: [
                // Logout Button
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.blue),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogOut()),
                    );
                    if (result == true) {
                      Navigator.of(context).pushReplacementNamed('/login');
                    }
                  },
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),

                const Divider(height: 10, thickness: 1),

                // Delete Account Button
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    'Delete Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeleteAccountPage()),
                    );
                    if (result == true) {
                      Navigator.of(context).pushReplacementNamed('/login');
                    }
                  },
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // App Version Info
            Center(
              child: Text(
                'App Version 1.0.0',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
