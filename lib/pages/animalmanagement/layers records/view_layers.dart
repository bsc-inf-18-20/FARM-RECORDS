import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_layers.dart'; // Import your UpdateLayersPage

class ViewLayers extends StatelessWidget {
  const ViewLayers({super.key});

  // Method to delete a layer record from Firestore
  Future<void> _deleteLayer(BuildContext context, String layerId) async {
    try {
      await FirebaseFirestore.instance
          .collection('layers_records')
          .doc(layerId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Layer record deleted successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting layer record: $e'),
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
          'Layers Records',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32), // Professional green
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('layers_records').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No layers records found.'));
          }

          final layers = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: layers.length,
            itemBuilder: (context, index) {
              final layer = layers[index].data() as Map<String, dynamic>;
              final layerId = layers[index].id;

              // Format the date
              String formattedDate = '';
              if (layer['date'] != null && layer['date'] is Timestamp) {
                formattedDate = (layer['date'] as Timestamp)
                    .toDate()
                    .toLocal()
                    .toString()
                    .split(' ')[0];
              }

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                color: Colors.white,
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
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Color.fromARGB(255, 26, 26, 26)),
                                tooltip: 'Edit Layer',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditLayersPage(
                                        layerId: layerId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Delete Layer',
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                      context, layerId);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      // Layer Details
                      _buildInfoRow('Number of Hens', layer['Number of Hens']),
                      _buildInfoRow('Eggs Collected Daily',
                          layer['eggs_collected_daily']),
                      _buildInfoRow(
                          'Feed Used (kg)', layer['feed_amount_in_kg']),
                      _buildInfoRow(
                          'Feed Cost (MKW)', layer['feed_cost_in_MKW']),
                      _buildInfoRow('Value (MKW)', layer['value_in_MKW']),
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

  void _showDeleteConfirmationDialog(BuildContext context, String layerId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Layer',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete this layer? This action cannot be undone.',
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
              _deleteLayer(context, layerId); // Perform deletion
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
