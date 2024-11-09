import 'package:farmrecord/pages/home/app_theme.dart';
import 'package:flutter/material.dart';
import '../crop.dart'; // Import CropPage for navigation

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 120),
                _buildRoundedBox(context, 'Field Operations Records', () {}),
                const SizedBox(height: 15),
                _buildRoundedBox(context, 'Crop Records', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CropPage()),
                  );
                }),
                const SizedBox(height: 15),
                _buildRoundedBox(context, 'Labour Records', () {}),
                const SizedBox(height: 15),
                _buildRoundedBox(context, 'Layers Records', () {}),
                const SizedBox(height: 15),
                _buildRoundedBox(context, 'Milk Production Records', () {}),
                const SizedBox(height: 15),
                _buildRoundedBox(context, 'Financial Records', () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedBox(
      BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 55,
        decoration: BoxDecoration(
          color: AppTheme().buttonColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(66, 255, 255, 255),
              offset: Offset(2, 2),
              blurRadius: 8,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            title,
            style: TextStyle(
              color: AppTheme().buttonTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
