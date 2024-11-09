// lib/view_activities.dart

import 'package:farmrecord/pages/update_activities';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ViewActivities extends StatelessWidget {
  const ViewActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Activities'),
        backgroundColor: const Color.fromARGB(255, 103, 58, 182),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Query to retrieve and order activities by date
        stream: FirebaseFirestore.instance
            .collection('activities')
            .orderBy('date',
                descending:
                    true) // Order by date in descending order (latest first)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No activities found.'));
          }

          final activities = snapshot.data!.docs;

          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              final Timestamp? dateTimestamp = activity['date'];
              final String dateFormatted = dateTimestamp != null
                  ? DateFormat('yyyy-MM-dd').format(dateTimestamp.toDate())
                  : 'N/A';
              final crop = activity['crop'] ?? 'N/A';
              final activityName = activity['activity'] ?? 'N/A';
              final expenditure = activity['expenditure']?.toString() ?? 'N/A';
              final farmName = activity['farmName'] ?? 'N/A';
              final income = activity['income']?.toString() ?? 'N/A';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text('$activityName on $crop'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: $dateFormatted'),
                      Text('Farm: $farmName'),
                      Text('Expenditure: \$$expenditure'),
                      Text('Income: \$$income'),
                    ],
                  ),
                  onTap: () {
                    // Navigate to UpdateActivity and pass the document reference
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UpdateActivity(activityDoc: activity),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
