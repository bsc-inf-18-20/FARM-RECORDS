import 'package:flutter/material.dart';

class LikeRateUsPage extends StatelessWidget {
  const LikeRateUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Farm Record App'),
        backgroundColor:
            const Color.fromARGB(255, 44, 133, 8), // Farm-inspired theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Loving the Farm Record App? Show your support!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement logic to open app store for rating
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 44, 133, 8),
              ),
              child: const Text('Rate Us on App Store'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement social media sharing logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 44, 133, 8),
              ),
              child: const Text('Share with Fellow Farmers'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your feedback helps us improve and reach more farmers. Thank you for your support!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
