import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewActivitiesPage extends StatelessWidget {
  const ViewActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Labour Activities'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('labour_records').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No activities found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['activity'] ?? 'No Activity'),
                subtitle:
                    Text('Plot: ${data['plot_number']}, Crop: ${data['crop']}'),
                trailing: Text((data['date'] as Timestamp)
                    .toDate()
                    .toLocal()
                    .toString()
                    .split(' ')[0]),
              );
            },
          );
        },
      ),
    );
  }
}
