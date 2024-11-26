import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'edit_crop_activity.dart';

class ViewCropsActivity extends StatelessWidget {
  final Color cardColor;

  const ViewCropsActivity({
    Key? key,
    required this.cardColor,
  }) : super(key: key);

  // Fetch activities from Firestore
  Stream<QuerySnapshot<Map<String, dynamic>>> _fetchCropActivities() {
    return FirebaseFirestore.instance
        .collection('crop_activities')
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Delete activity from Firestore
  Future<void> _deleteActivity(BuildContext context, String activityId) async {
    try {
      await FirebaseFirestore.instance
          .collection('crop_activities')
          .doc(activityId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activity deleted successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete activity: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Activities'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _fetchCropActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No crop activities found.'));
          }

          final activities = snapshot.data!.docs;

          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index].data();
              final activityId = activities[index].id; // Get document ID

              return Card(
                color: cardColor,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Crop Activity',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                tooltip: 'Edit Activity',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditCropActivity(
                                        activityId: activityId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Delete Activity',
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                      context, activityId);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('Plot Number', activity['plot_number']),
                      _buildInfoRow('Plot Size (Hectares)',
                          activity['plot_size_in_hectares']),
                      _buildInfoRow('Crop', activity['crop']),
                      _buildInfoRow('Seed Type', activity['seed_type']),
                      _buildInfoRow(
                          'Seed Amount (KG)', activity['seed_amount_in_kgs']),
                      _buildInfoRow(
                          'Fertilizer Type', activity['fertilizer_type']),
                      _buildInfoRow('Fertilizer Amount (KG)',
                          activity['fertilizer_amount_in_kgs']),
                      _buildInfoRow('Spray Type', activity['spray_type']),
                      _buildInfoRow('Spray Amount (Litres)',
                          activity['spray_amount_in_litres']),
                      _buildInfoRow(
                        'Date',
                        (activity['date'] as Timestamp)
                            .toDate()
                            .toLocal()
                            .toString()
                            .split(' ')[0],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value.toString()),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String activityId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Activity'),
        content: const Text('Are you sure you want to delete this activity?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel button
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              _deleteActivity(context, activityId); // Perform deletion
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
