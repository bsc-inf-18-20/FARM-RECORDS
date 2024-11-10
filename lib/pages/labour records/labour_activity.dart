import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LabourActivityPage extends StatefulWidget {
  final Color appBarColor;
  final Color buttonColor;
  final Color formFieldBorderColor;

  const LabourActivityPage({
    super.key,
    this.appBarColor = Colors.teal, // Default color
    this.buttonColor = Colors.teal, // Default button color
    this.formFieldBorderColor = Colors.grey, // Default form field border color
  });

  @override
  _LabourActivityPageState createState() => _LabourActivityPageState();
}

class _LabourActivityPageState extends State<LabourActivityPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _plotNumberController = TextEditingController();
  final TextEditingController _plotSizeController = TextEditingController();
  final TextEditingController _cropController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _workDoneController = TextEditingController();
  DateTime? _selectedDate;

  // Validators for real-time input validation
  String? _validateTextOnly(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    if (RegExp(r'[0-9]').hasMatch(value)) {
      return 'Please enter valid text, no numbers allowed';
    }
    return null;
  }

  String? _validateNumberOnly(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    if (RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Please enter valid numbers, no letters allowed';
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitActivity() async {
    if (_formKey.currentState?.validate() != true || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all fields and select a date.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('labour_records').add({
        'plot_number': _plotNumberController.text,
        'plot_size': _plotSizeController.text,
        'crop': _cropController.text,
        'activity': _activityController.text,
        'work_done': _workDoneController.text,
        'date': Timestamp.fromDate(_selectedDate!),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Labour activity added successfully!')),
      );
      _clearFields();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void _clearFields() {
    _plotNumberController.clear();
    _plotSizeController.clear();
    _cropController.clear();
    _activityController.clear();
    _workDoneController.clear();
    setState(() {
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Labour Activity',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: widget.appBarColor, // Customizable app bar color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Adjusting column size
                children: [
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Select Date',
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                        errorText: _selectedDate == null
                            ? 'Please choose a date'
                            : null,
                      ),
                      child: Text(
                        _selectedDate == null
                            ? 'Choose Date'
                            : '${_selectedDate!.toLocal()}'.split(' ')[0],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildTextFormField(_plotNumberController, 'Plot Number',
                      icon: Icons.pin_drop, inputType: TextInputType.number),
                  const SizedBox(height: 15),
                  _buildTextFormField(
                      _plotSizeController, 'Plot Size (e.g., hectares)',
                      icon: Icons.square_foot, inputType: TextInputType.number),
                  const SizedBox(height: 15),
                  _buildTextFormField(_cropController, 'Crop',
                      icon: Icons.local_florist,
                      inputType: TextInputType.text,
                      isTextOnly: true),
                  const SizedBox(height: 15),
                  _buildTextFormField(_activityController, 'Activity',
                      icon: Icons.work,
                      inputType: TextInputType.text,
                      isTextOnly: true),
                  const SizedBox(height: 15),
                  _buildTextFormField(_workDoneController, 'Work Done',
                      icon: Icons.done_all, inputType: TextInputType.number),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitActivity,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0), // Smaller button size
                      backgroundColor:
                          widget.buttonColor, // Customizable button color
                    ),
                    child: const Text('Submit Activity',
                        style: TextStyle(fontSize: 14)), // Smaller text size
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String labelText,
      {required IconData icon,
      TextInputType inputType = TextInputType.text,
      bool isTextOnly = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.formFieldBorderColor, // Customizable border color
          ),
        ),
      ),
      validator: isTextOnly ? _validateTextOnly : _validateNumberOnly,
      onChanged: (value) {
        setState(() {
          // Trigger form validation on each change
        });
      },
    );
  }
}
