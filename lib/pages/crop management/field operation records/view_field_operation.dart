import 'package:farmrecord/pages/crop%20management/field%20operation%20records/update_field_operation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewFieldOperationActivities extends StatelessWidget {
  final Color cardColor;

  const ViewFieldOperationActivities({
    Key? key,
    this.cardColor = Colors.white, // Default card color changed to white
  }) : super(key: key);

  Stream<QuerySnapshot<Map<String, dynamic>>> _fetchFieldOperations() {
    return FirebaseFirestore.instance
        .collection('field_operations')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<void> _deleteActivity(BuildContext context, String activityId) async {
    try {
      await FirebaseFirestore.instance
          .collection('field_operations')
          .doc(activityId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Activity deleted successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete activity: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Field Operation Activities',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00796B), // Teal color
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _fetchFieldOperations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching data.',
                  style: TextStyle(color: Colors.red)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No field operation activities found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final activities = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index].data();
              final activityId = activities[index].id;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                color: Colors.white, // Set card background color to white
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Field Operation #${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Color.fromARGB(255, 35, 36, 36)),
                                tooltip: 'Edit Activity',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateFieldOperation(
                                        yieldId: activityId,
                                        existingData: activity,
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
                      const Divider(),
                      // Activity Details
                      _buildInfoRow('Plot Number', activity['plot_number']),
                      _buildInfoRow('Plot Size (Hectares)',
                          activity['plot_size_hectares']),
                      _buildInfoRow(
                          'Operation Activity', activity['operation_activity']),
                      _buildInfoRow('Input Type', activity['input_type']),
                      _buildInfoRow(
                          'Input Amount (Kg)', activity['input_amount_kg']),
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title:',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          Flexible(
            child: Text(
              value?.toString() ?? 'N/A',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String activityId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Activity',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete this activity? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel button
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              _deleteActivity(context, activityId); // Perform deletion
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
