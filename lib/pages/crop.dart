import 'package:flutter/material.dart';

class CropPage extends StatelessWidget {
  const CropPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Activities'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rounded box for Add New Activity
            _buildRoundedBox(context, 'Add New Activity', Icons.add),
            const SizedBox(height: 15), // Space between the boxes
            // Rounded box for Update Activity
            _buildRoundedBox(context, 'Update Activity', Icons.edit),
            const SizedBox(height: 15), // Space between the boxes
            // Rounded box for View Activities
            _buildRoundedBox(context, 'View Activities', Icons.visibility),
            const SizedBox(height: 15), // Space between the boxes
            // Rounded box for Delete Activity
            _buildRoundedBox(context, 'Delete Activity', Icons.delete),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedBox(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        // Implement navigation or functionality here
        // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
      },
      child: Container(
        width: 200, // Adjusted width for a smaller box
        height: 50, // Adjusted height for a smaller box
        decoration: BoxDecoration(
          color: Colors.blueAccent, // Background color
          borderRadius:
              BorderRadius.circular(10), // Slightly smaller rounded corners
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24, // Smaller size for the icon
            ),
            const SizedBox(width: 10), // Space between the icon and text
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16, // Smaller font size for the text
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
