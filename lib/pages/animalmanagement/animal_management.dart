import 'package:farmrecord/pages/animalmanagement/layers%20records/layers_records.dart';
import 'package:farmrecord/pages/home/app_theme.dart';
import 'package:flutter/material.dart';

class AnimalManagement extends StatelessWidget {
  const AnimalManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme(); // Get the app theme

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.appBarColor, // Use appBarColor from AppTheme
        title: Text(
          'Farm Records',
          style: appTheme.textStyle.copyWith(
            color: appTheme.buttonTextColor, // Title text color from AppTheme
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height, // Full height of the screen
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/images/farming.jpg'), // Ensure correct path
            fit: BoxFit.cover, // Ensures the image covers the entire background
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 200),

                    const SizedBox(height: 15),
                    _buildRoundedBox(context, 'Layers Records', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LayersRecords()),
                      );
                    }),

                    // const SizedBox(height: 15),
                    // _buildRoundedBox(context, 'Financial Records', () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const FinancialPage()),
                    //   );
                    // }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedBox(
      BuildContext context, String title, VoidCallback onTap) {
    final appTheme = AppTheme(); // Get the app theme

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 55,
        decoration: BoxDecoration(
          color: appTheme.buttonColor.withOpacity(0.9), // Use buttonColor
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(66, 255, 255, 255),
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
            style: appTheme.textStyle.copyWith(
              color:
                  appTheme.buttonTextColor, // Button text color from AppTheme
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
