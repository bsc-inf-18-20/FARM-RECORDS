import 'package:farmrecord/pages/settings/HelpPage.dart';
import 'package:farmrecord/pages/settings/InvitePage.dart';
import 'package:farmrecord/pages/settings/LikeRateUsPage.dart';
import 'package:farmrecord/pages/settings/OurPlansPage.dart';
import 'package:farmrecord/pages/settings/about_us';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChange;

  const SettingsPage({
    super.key,
    this.isDarkMode = false, // Default value for isDarkMode
    this.onThemeChange = _defaultThemeChange, // Default no-op function
  });

  static void _defaultThemeChange(bool value) {
    print('Theme change callback not provided');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: isDarkMode,
              onChanged: onThemeChange,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildSettingOption('Our Plans', Icons.assignment, context,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OurPlansPage()),
                    );
                  }),
                  _buildSettingOption('Help', Icons.help, context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpPage()),
                    );
                  }),
                  _buildSettingOption(
                      'Invite Friends', Icons.person_add, context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InvitePage()),
                    );
                  }),
                  _buildSettingOption('Like or Rate Us', Icons.star, context,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LikeRateUsPage()),
                    );
                  }),
                  _buildSettingOption('About Us', Icons.info, context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutUsPage()),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption(
    String title,
    IconData icon,
    BuildContext context,
    VoidCallback onTap, {
    Color tileColor = Colors.white,
    Color textColor = Colors.black,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: textColor),
        title: Text(title, style: TextStyle(color: textColor)),
        tileColor: tileColor,
        onTap: onTap,
      ),
    );
  }
}
