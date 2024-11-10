import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewYieldsPage extends StatelessWidget {
  const ViewYieldsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Yield Records'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('yield_records').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No yield records found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['crop'] ?? 'No Crop'),
                subtitle: Text(
                  'crop : ${data['crop']},   Field: ${data['field_plot']},   Hectare: ${data['hectare']},     Yield: ${data['yield']}',
                ),
                trailing: Text(
                  (data['date'] as Timestamp)
                      .toDate()
                      .toLocal()
                      .toString()
                      .split(' ')[0],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
