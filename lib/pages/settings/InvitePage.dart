import 'package:flutter/material.dart';

class InvitePage extends StatelessWidget {
  const InvitePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Friends'),
        backgroundColor:
            const Color.fromARGB(255, 44, 133, 8), // Farm-themed color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Invite your fellow farmers to use the Farm Record App and help them simplify their record-keeping!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.email),
              label: const Text('Invite via Email'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 44, 133, 8),
              ),
              onPressed: () {
                // Implement email invitation logic
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.sms),
              label: const Text('Invite via SMS'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 44, 133, 8),
              ),
              onPressed: () {
                // Implement SMS invitation logic
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Share on Social Media'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 44, 133, 8),
              ),
              onPressed: () {
                // Implement social media sharing logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
