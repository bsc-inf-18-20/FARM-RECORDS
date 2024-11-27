import 'package:farmrecord/pages/crop%20management/labour%20records/labour%20activity/labour_activity.dart';
import 'package:farmrecord/pages/crop%20management/labour%20records/view_activities.dart';
import 'package:flutter/material.dart';

class LabourPage extends StatefulWidget {
  const LabourPage({super.key});

  @override
  _LabourPageState createState() => _LabourPageState();
}

class _LabourPageState extends State<LabourPage> {
  // Navigation functions for buttons
  void _navigateToAddActivity(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LabourActivityPage()),
    );
  }

  void _navigateToViewActivities(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ViewActivitiesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LabourAppBar(
        onAddActivity: () => _navigateToAddActivity(context),
        onViewActivities: () => _navigateToViewActivities(context),
      ),
      body: Column(
        children: [
          // Image banner at the top
          _buildImageBanner(),
          const SizedBox(height: 10),
          // Main content buttons
          Expanded(
            child: MainContentButtons(
              onAddActivity: () => _navigateToAddActivity(context),
              onViewActivities: () => _navigateToViewActivities(context),
            ),
          ),
        ],
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
class LabourAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAddActivity;
  final VoidCallback onViewActivities;

  const LabourAppBar({
    Key? key,
    required this.onAddActivity,
    required this.onViewActivities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Labour Records',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 44, 133, 8),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Add Activity',
          onPressed: onAddActivity,
        ),
        IconButton(
          icon: const Icon(Icons.visibility),
          tooltip: 'View Activities',
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
            title: 'Add New Activity',
            icon: Icons.add,
            onPressed: onAddActivity,
          ),
          const SizedBox(height: 20),
          RoundedBoxButton(
            title: 'View Activities',
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
