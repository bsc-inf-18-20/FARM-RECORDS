import 'package:flutter/material.dart';
import 'labour_activity_form.dart';
import 'labour_activity_repository.dart';

class LabourActivityPage extends StatelessWidget {
  final Color appBarColor;
  final Color buttonColor;
  final Color formFieldBorderColor;

  const LabourActivityPage({
    super.key,
    this.appBarColor = const Color.fromARGB(255, 44, 133, 8),
    this.buttonColor = const Color.fromARGB(255, 44, 133, 8),
    this.formFieldBorderColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Labour Activity',
            style: TextStyle(color: Colors.white)),
        backgroundColor: appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LabourActivityForm(
          buttonColor: buttonColor,
          formFieldBorderColor: formFieldBorderColor,
          onSubmit: (data) => _submitToFirestore(data, context),
        ),
      ),
    );
  }

  Future<void> _submitToFirestore(
      Map<String, dynamic> data, BuildContext context) async {
    final repository = LabourActivityRepository();
    try {
      await repository.addLabourActivity(data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Labour activity added successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }
}
