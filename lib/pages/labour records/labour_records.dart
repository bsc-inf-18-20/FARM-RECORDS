import 'package:farmrecord/pages/labour%20records/labour_activity.dart';
import 'package:farmrecord/pages/labour%20records/view_activities.dart';
import 'package:flutter/material.dart';

class LabourPage extends StatelessWidget {
  const LabourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Labour Records'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoundedBox(context, 'Add New Activity', Icons.add),
            const SizedBox(height: 15),
            _buildRoundedBox(context, 'Update Activity', Icons.edit),
            const SizedBox(height: 15),
            _buildRoundedBox(context, 'View Activities', Icons.visibility),
            const SizedBox(height: 15),
            _buildRoundedBox(context, 'Delete Activity', Icons.delete),
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
            MaterialPageRoute(builder: (context) => const LabourActivityPage()),
          );
        } else if (title == 'View Activities') {
          // Navigate to ViewActivitiesPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const ViewActivitiesPage()), // Ensure this page exists
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
