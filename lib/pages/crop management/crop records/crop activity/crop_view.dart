import 'package:farmrecord/pages/crop%20management/crop%20records/crop%20activity/crop_activity.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For fetching crop activity data

class CropRecordsPage extends StatefulWidget {
  const CropRecordsPage({super.key});

  @override
  _CropRecordsPageState createState() => _CropRecordsPageState();
}

class _CropRecordsPageState extends State<CropRecordsPage> {
  // Navigation functions for buttons
  void _navigateToAddActivity(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CropActivity()),
    );
  }

  // Here we pass an activityId to the CropView widget
  void _navigateToViewActivities(BuildContext context) {
    String activityId =
        'sample_activity_id'; // Dynamically fetch or select this ID

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CropView(activityId: activityId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CropAppBar(
        onAddActivity: () => _navigateToAddActivity(context),
        onViewActivities: () => _navigateToViewActivities(context),
      ),
      body: SingleChildScrollView(
        // Wrap the entire body in a SingleChildScrollView
        child: Column(
          children: [
            // Image banner at the top
            _buildImageBanner(),
            const SizedBox(height: 10),
            // Main content buttons
            const SizedBox(
                height: 20), // Adjusted space between the image and buttons
            MainContentButtons(
              onAddActivity: () => _navigateToAddActivity(context),
              onViewActivities: () => _navigateToViewActivities(context),
            ),
          ],
        ),
      ),
    );
  }

  // Image banner function to display the image at the top
  Widget _buildImageBanner() {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Image.asset(
          'assets/image1.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// Custom AppBar with navigation actions
class CropAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAddActivity;
  final VoidCallback onViewActivities;

  const CropAppBar({
    Key? key,
    required this.onAddActivity,
    required this.onViewActivities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Crop Records',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 44, 133, 8),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Add Crop Activity',
          onPressed: onAddActivity,
        ),
        IconButton(
          icon: const Icon(Icons.visibility),
          tooltip: 'View Crop Activities',
          onPressed: onViewActivities,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Main content with buttons for navigating to different pages
class MainContentButtons extends StatelessWidget {
  final VoidCallback onAddActivity;
  final VoidCallback onViewActivities;

  const MainContentButtons({
    Key? key,
    required this.onAddActivity,
    required this.onViewActivities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RoundedBoxButton(
            title: 'New Crop Activity',
            icon: Icons.add,
            onPressed: onAddActivity,
          ),
          const SizedBox(height: 20),
          RoundedBoxButton(
            title: 'View Crop Activities',
            icon: Icons.visibility,
            onPressed: onViewActivities,
          ),
        ],
      ),
    );
  }
}

// Reusable rounded button widget for actions
class RoundedBoxButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const RoundedBoxButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 220,
        height: 60,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 44, 133, 8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Crop View widget to display details of the selected crop activity
class CropView extends StatelessWidget {
  final String activityId;

  const CropView({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Activity Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        // Fetch the data for the given activityId
        future: FirebaseFirestore.instance
            .collection('crop_activities')
            .doc(activityId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
                child: Text('No data found for this activity.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activity: ${data['activity'] ?? 'N/A'}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text('Date: ${data['date'] ?? 'N/A'}'),
                Text('Crop: ${data['crop'] ?? 'N/A'}'),
                Text('Plot: ${data['plot_number'] ?? 'N/A'}'),
                Text('Work Done: ${data['work_done'] ?? 'N/A'}'),
                Text('Plot Size: ${data['plot_size'] ?? 'N/A'}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
