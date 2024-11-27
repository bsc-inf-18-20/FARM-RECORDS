import 'package:flutter/material.dart';
import 'crop activity/crop_activity.dart';
import 'crop activity/view_crops_activity.dart';

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

  void _navigateToViewActivities(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ViewCropsActivity(
          cardColor: Colors.white, // Provide the cardColor argument here
        ),
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
        child: Column(
          children: [
            _buildImageBanner(),
            const SizedBox(height: 20),
            MainContentButtons(
              onAddActivity: () => _navigateToAddActivity(context),
              onViewActivities: () => _navigateToViewActivities(context),
            ),
          ],
        ),
      ),
    );
  }

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
            offset: const Offset(0, 4),
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
              offset: const Offset(0, 3),
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
