import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor:
            const Color.fromARGB(255, 44, 133, 8), // Farm-themed color
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            title: Text('How to add a new crop activity'),
            subtitle: Text(
                'Step-by-step guide on adding and managing crop activities in the app.'),
          ),
          Divider(),
          ListTile(
            title: Text('How to record expenses and income'),
            subtitle: Text(
                'Instructions for logging farm-related expenses and tracking income.'),
          ),
          Divider(),
          ListTile(
            title: Text('Viewing and exporting records'),
            subtitle: Text(
                'Learn how to view and export farm records for better analysis.'),
          ),
          Divider(),
          ListTile(
            title: Text('Contact Support'),
            subtitle:
                Text('Email: farmrecordapp@example.com\nPhone: +123 456 7890'),
          ),
        ],
      ),
    );
  }
}
