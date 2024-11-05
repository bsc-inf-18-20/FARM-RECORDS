import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showAddActivityDialog(BuildContext context) {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController cropController = TextEditingController();
  final TextEditingController activityController = TextEditingController();
  final TextEditingController expenditureController = TextEditingController();
  final TextEditingController farmNameController = TextEditingController();
  final TextEditingController incomeController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add New Activity'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date'),
              ),
              TextField(
                controller: cropController,
                decoration: const InputDecoration(labelText: 'Crop'),
              ),
              TextField(
                controller: activityController,
                decoration: const InputDecoration(labelText: 'Activity'),
              ),
              TextField(
                controller: expenditureController,
                decoration: const InputDecoration(labelText: 'Expenditure'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: farmNameController,
                decoration: const InputDecoration(labelText: 'Farm Name'),
              ),
              TextField(
                controller: incomeController,
                decoration: const InputDecoration(labelText: 'Income'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Input validation
              if (dateController.text.isEmpty ||
                  cropController.text.isEmpty ||
                  activityController.text.isEmpty ||
                  expenditureController.text.isEmpty ||
                  farmNameController.text.isEmpty ||
                  incomeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill out all fields!')),
                );
                return;
              }

              if (double.tryParse(expenditureController.text) == null ||
                  double.tryParse(incomeController.text) == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Expenditure and Income must be valid numbers!')),
                );
                return;
              }

              // If validation passes, add the activity
              await addActivityToDatabase(
                context,
                dateController.text,
                cropController.text,
                activityController.text,
                double.parse(expenditureController.text),
                farmNameController.text,
                double.parse(incomeController.text),
              );
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Add Activity'),
          ),
        ],
      );
    },
  );
}

// Method to add activity to Firestore
Future<void> addActivityToDatabase(
    BuildContext context,
    String date,
    String crop,
    String activity,
    double expenditure,
    String farmName,
    double income) async {
  try {
    await FirebaseFirestore.instance.collection('activities').add({
      'date': date,
      'crop': crop,
      'activity': activity,
      'expenditure': expenditure,
      'farmName': farmName,
      'income': income,
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Activity added successfully!')),
    );
  } catch (e) {
    // Handle error here (e.g., show an error message)
    print('Failed to add activity: $e');

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to add activity: $e')),
    );
  }
}
