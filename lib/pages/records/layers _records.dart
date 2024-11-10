import 'package:flutter/material.dart';
import '../add_activity.dart'; // Import your add_activity.dart file

class LayersPage extends StatelessWidget {
  const LayersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layers Records'),
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
          showAddActivityDialog(context);
        }
      },
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
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
