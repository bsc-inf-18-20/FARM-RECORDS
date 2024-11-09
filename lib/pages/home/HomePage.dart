import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_content.dart'; // Import HomeContent class
import 'settings_page.dart'; // Import SettingsPage class
import 'profile_page.dart'; // Import ProfilePage class
import 'app_theme.dart'; // Import AppTheme class

class HomePage extends StatelessWidget {
  final User? user;
  final IAppTheme appTheme;

  const HomePage({super.key, required this.user, required this.appTheme});

  @override
  Widget build(BuildContext context) {
    return HomePageBody(appTheme: appTheme, user: user);
  }
}

class HomePageBody extends StatefulWidget {
  final User? user;
  final IAppTheme appTheme;

  const HomePageBody({super.key, required this.user, required this.appTheme});

  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const SettingsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: _pages[_selectedIndex],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: widget.appTheme.bottomNavBarColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: widget.appTheme.buttonTextColor,
        unselectedItemColor: widget.appTheme.unselectedIconColor,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: widget.appTheme.appBarColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Farm Records',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: widget.appTheme.buttonTextColor,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ],
    );
  }
}
