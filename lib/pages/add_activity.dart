import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting date
import 'package:flutter/services.dart'; // For input formatters

void showAddActivityDialog(BuildContext context) {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController cropController = TextEditingController();
  final TextEditingController activityController = TextEditingController();
  final TextEditingController expenditureController = TextEditingController();
  final TextEditingController farmNameController = TextEditingController();
  final TextEditingController incomeController = TextEditingController();

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      dateController.text =
          formattedDate; // Update controller with the selected date
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add New Activity'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              // Date Picker
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true, // Make the field read-only
                onTap: () => selectDate(context), // Open date picker on tap
              ),
              // Text Field for Crop with Text Validation
              TextField(
                controller: cropController,
                decoration: const InputDecoration(
                  labelText: 'Crop',
                  prefixIcon: Icon(Icons.agriculture),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
                ],
              ),
              // Text Field for Activity with Text Validation
              TextField(
                controller: activityController,
                decoration: const InputDecoration(
                  labelText: 'Activity',
                  prefixIcon: Icon(Icons.work),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
                ],
              ),
              // Text Field for Expenditure with Number Validation
              TextField(
                controller: expenditureController,
                decoration: const InputDecoration(
                  labelText: 'Expenditure',
                  prefixIcon: Icon(Icons.money_off),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+(\.\d{0,2})?$')),
                ],
              ),
              // Text Field for Farm Name with Text Validation
              TextField(
                controller: farmNameController,
                decoration: const InputDecoration(
                  labelText: 'Farm Name',
                  prefixIcon: Icon(Icons.landscape),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
                ],
              ),
              // Text Field for Income with Number Validation
              TextField(
                controller: incomeController,
                decoration: const InputDecoration(
                  labelText: 'Income',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+(\.\d{0,2})?$')),
                ],
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
