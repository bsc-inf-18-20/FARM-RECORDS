import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Assuming you have a CropPage defined somewhere
import 'crop.dart'; // Import your CropPage

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({super.key, required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Current index for the bottom navigation bar

  // List of pages for the bottom navigation
  final List<Widget> _pages = [
    const HomeContent(), // Home content (this can be a separate widget)
    const SettingsPage(), // Placeholder for Settings Page
    const ProfilePage(), // Placeholder for Profile Page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Current selected index
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the current index
          });
        },
      ),
    );
  }
}

// Home content widget
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rounded box for Crop Production
          _buildRoundedBox(context, 'Crop Production', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const CropPage()), // Navigate to CropPage
            );
          }),
          const SizedBox(height: 20), // Space between the boxes
          // Rounded box for Animal Production
          _buildRoundedBox(context, 'Animal Production', () {
            // Implement navigation for Animal Production if you have a page
          }),
        ],
      ),
    );
  }

  Widget _buildRoundedBox(
      BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, // Call the passed callback when tapped
      child: Container(
        width: 200, // Width of the rounded box
        height: 100, // Height of the rounded box
        decoration: BoxDecoration(
          color: Colors.blueAccent, // Background color
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Placeholder for Settings Page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings Page'),
    );
  }
}

// Placeholder for Profile Page
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Page'),
    );
  }
}
