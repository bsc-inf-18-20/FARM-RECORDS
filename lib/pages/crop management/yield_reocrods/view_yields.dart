import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'update_yields.dart';

class ViewYieldsPage extends StatelessWidget {
  final Color cardColor;

  const ViewYieldsPage({
    Key? key,
    required this.cardColor,
  }) : super(key: key);

  // Fetch yield records from Firestore
  Stream<QuerySnapshot<Map<String, dynamic>>> _fetchYields() {
    return FirebaseFirestore.instance
        .collection('yield_records')
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Delete yield record from Firestore
  Future<void> _deleteYield(BuildContext context, String yieldId) async {
    try {
      await FirebaseFirestore.instance
          .collection('yield_records')
          .doc(yieldId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Yield record deleted successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete yield record: $e'),
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
          'Yield Records',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32), // Professional green
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _fetchYields(),
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
                'No yield records found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final yields = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: yields.length,
            itemBuilder: (context, index) {
              final yieldRecord = yields[index].data();
              final yieldId = yields[index].id;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                color: Colors.white, // Set the background color to white
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
                            'Yield Record #${index + 1}',
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
                                    color: Color.fromARGB(255, 82, 80, 80)),
                                tooltip: 'Edit Yield',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateYieldPage(
                                        yieldId: yieldId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Delete Yield',
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                      context, yieldId);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      // Yield Details
                      _buildInfoRow('Crop', yieldRecord['crop']),
                      _buildInfoRow('Field Plot', yieldRecord['field_plot']),
                      _buildInfoRow('Hectares', yieldRecord['hectares']),
                      _buildInfoRow(
                          'Yields in KGs', yieldRecord['yields in KGs']),
                      _buildInfoRow(
                        'Date',
                        (yieldRecord['date'] as Timestamp)
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

  // Helper function to create info rows
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
              value.toString(),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // Function to show delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, String yieldId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Yield Record',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete this yield record? This action cannot be undone.',
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
              _deleteYield(context, yieldId); // Perform deletion
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
