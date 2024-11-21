import 'package:farmrecord/pages/crop%20management/yield_reocrods/view_yields.dart';
import 'package:farmrecord/pages/crop%20management/yield_reocrods/yeild_activities.dart';
import 'package:flutter/material.dart';

class YieldRecords extends StatelessWidget {
  const YieldRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yield Records'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoundedBox(context, 'Add New Activity', Icons.add),
            const SizedBox(height: 15),
            _buildRoundedBox(context, 'View Activities', Icons.visibility),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedBox(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (title == 'Add New Activity') {
          // Navigate to LabourActivityPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const YieldActivityPage()),
          );
        } else if (title == 'View Activities') {
          // Navigate to ViewActivitiesPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const ViewYieldsPage()), // Ensure this page exists
          );
        }
        // Add additional conditions here for "Update Activity" and "Delete Activity"
      },
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
