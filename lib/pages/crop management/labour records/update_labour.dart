import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Importing for TextInputFormatter

class UpdateActivityPage extends StatefulWidget {
  final String activityId; // The ID of the activity to be updated
  const UpdateActivityPage({required this.activityId, super.key});

  @override
  _UpdateActivityPageState createState() => _UpdateActivityPageState();
}

class _UpdateActivityPageState extends State<UpdateActivityPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _activityController;
  late TextEditingController _plotNumberController;
  late TextEditingController _plotSizeController;
  late TextEditingController _cropController;
  late TextEditingController _workDoneController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _activityController = TextEditingController();
    _plotNumberController = TextEditingController();
    _plotSizeController = TextEditingController();
    _cropController = TextEditingController();
    _workDoneController = TextEditingController();
    _selectedDate = DateTime.now(); // Default to current date

    // Load the existing data from Firestore
    _loadActivityData();
  }

  // Load data for the activity
  void _loadActivityData() async {
    final doc = await FirebaseFirestore.instance
        .collection('labour_records')
        .doc(widget.activityId)
        .get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      _activityController.text = data['activity'] ?? '';
      _plotNumberController.text = data['plot_number'] ?? '';
      _plotSizeController.text = data['plot_size'] ?? '';
      _cropController.text = data['crop'] ?? '';
      _workDoneController.text = data['work_done'] ?? '';
      _selectedDate = (data['date'] as Timestamp).toDate();
      setState(() {});
    }
  }

  // Update the activity in Firestore
  void _updateActivity() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'activity': _activityController.text,
        'plot_number': _plotNumberController.text,
        'plot_size': _plotSizeController.text,
        'crop': _cropController.text,
        'work_done': _workDoneController.text,
        'date': Timestamp.fromDate(_selectedDate),
      };

      await FirebaseFirestore.instance
          .collection('labour_records')
          .doc(widget.activityId)
          .update(updatedData);

      // Go back to the previous screen after update
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Labour Activity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Activity (Text only)
                TextFormField(
                  controller: _activityController,
                  decoration: const InputDecoration(
                    labelText: 'Activity',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter activity';
                    }
                    if (!_isText(value)) {
                      return 'Activity must contain only text';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Plot Number (Numbers only)
                TextFormField(
                  controller: _plotNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Plot Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter plot number';
                    }
                    if (!_isNumber(value)) {
                      return 'Plot number must be a number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Plot Size (Numbers only)
                TextFormField(
                  controller: _plotSizeController,
                  decoration: const InputDecoration(
                    labelText: 'Plot Size',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter plot size';
                    }
                    if (!_isNumber(value)) {
                      return 'Plot size must be a number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Crop (Text only)
                TextFormField(
                  controller: _cropController,
                  decoration: const InputDecoration(
                    labelText: 'Crop',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter crop';
                    }
                    if (!_isText(value)) {
                      return 'Crop must contain only text';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Work Done (Numbers only)
                TextFormField(
                  controller: _workDoneController,
                  decoration: const InputDecoration(
                    labelText: 'Work Done',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter work done';
                    }
                    if (!_isNumber(value)) {
                      return 'Work done must be a number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Date Picker
                Row(
                  children: [
                    Text('Date: ${_selectedDate.toLocal()}'),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != _selectedDate) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Update Button
                ElevatedButton(
                  onPressed: _updateActivity,
                  child: const Text('Update Activity'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods to validate inputs
  bool _isText(String value) {
    return RegExp(r'^[a-zA-Z\s]+$')
        .hasMatch(value); // Checks for alphabets and spaces
  }

  bool _isNumber(String value) {
    return RegExp(r'^[0-9]+$').hasMatch(value); // Checks for numeric values
  }
}
