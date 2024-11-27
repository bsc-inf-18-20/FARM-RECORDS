import 'package:flutter/material.dart';

class ManageSubscriptionPage extends StatelessWidget {
  const ManageSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Subscription'),
        backgroundColor:
            const Color.fromARGB(255, 44, 133, 8), // Farm-themed color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Current Plan: Farm Pro'),
              subtitle: const Text('Renews on: December 15, 2024'),
              trailing: ElevatedButton(
                onPressed: () {
                  // Add logic to upgrade or modify the plan
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 44, 133, 8),
                ),
                child: const Text('Upgrade'),
              ),
            ),
            ListTile(
              title: const Text('Payment Details'),
              subtitle: const Text('Card ending in 5678'),
              trailing: ElevatedButton(
                onPressed: () {
                  // Add logic for updating payment method
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 44, 133, 8),
                ),
                child: const Text('Update'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add logic for subscription cancellation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Cancel Subscription'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Upgrade to access premium features, including detailed farm analytics and exportable records.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
