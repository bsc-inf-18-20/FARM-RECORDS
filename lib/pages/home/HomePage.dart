import 'package:farmrecord/pages/animalmanagement/animal_management.dart';
import 'package:farmrecord/pages/home/app_theme.dart';
import 'package:farmrecord/pages/crop%20management/crop_management.dart';
import 'package:farmrecord/pages/log_in.dart';
import 'package:farmrecord/pages/profile/user_profile.dart';
import 'package:farmrecord/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  final User user;
  final AppTheme appTheme;

  const HomePage({
    Key? key,
    required this.user,
    required this.appTheme,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AnimalManagement()),
        );
        break;
      case 1: // Profile selected
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfile()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
        break;
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '      FARM MANAGEMENT',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: widget.appTheme.appBarColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            _buildRoundedBox(
                context, 'Crop Management', widget.appTheme.primaryColor),
            const SizedBox(height: 20),
            _buildRoundedBox(context, 'Animal Management', Colors.orange),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: widget.appTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildRoundedBox(BuildContext context, String title, Color color) {
    return GestureDetector(
      onTap: () {
        if (title == 'Crop Management') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CropManagement()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AnimalManagement()),
          );
        }
      },
      child: Container(
        width: 280,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: 2),
        ),
        child: Center(
          child: Text(
            title,
            style: widget.appTheme.textStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
