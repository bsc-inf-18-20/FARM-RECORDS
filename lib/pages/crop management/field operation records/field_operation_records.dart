import 'package:farmrecord/pages/crop%20management/yield_reocrods/view_yields.dart';
import 'package:farmrecord/pages/crop%20management/yield_reocrods/yeild_activities.dart';
import 'package:flutter/material.dart';

class FieldOperationRecords extends StatefulWidget {
  const FieldOperationRecords({super.key});

  @override
  FieldOperationRecordsState createState() => FieldOperationRecordsState();
}

class FieldOperationRecordsState extends State<FieldOperationRecords> {
  // Navigation functions for buttons
  void _navigateToAddActivity(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const YieldActivityPage()),
    );
  }

  void _navigateToViewActivities(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ViewYieldsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YieldAppBar(
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
          'assets/image1.jpg', // Change to your desired image path
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// Custom AppBar with navigation actions
class YieldAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAddActivity;
  final VoidCallback onViewActivities;

  const YieldAppBar({
    Key? key,
    required this.onAddActivity,
    required this.onViewActivities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Yield Records',
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
