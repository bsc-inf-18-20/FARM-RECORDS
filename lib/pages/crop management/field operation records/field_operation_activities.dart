import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FieldOperationActivities extends StatefulWidget {
  final Color appBarColor;
  final Color buttonColor;
  final Color formFieldBorderColor;

  const FieldOperationActivities({
    super.key,
    this.appBarColor = Colors.teal, // Default app bar color
    this.buttonColor = Colors.teal, // Default button color
    this.formFieldBorderColor = Colors.grey, // Default form field border color
  });

  @override
  // ignore: library_private_types_in_public_api
  _FieldOperationActivitiesState createState() =>
      _FieldOperationActivitiesState();
}

class _FieldOperationActivitiesState extends State<FieldOperationActivities> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cropController = TextEditingController();
  final TextEditingController _plotController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;

  // Validation for Text Only
  String? _validateTextOnly(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a value';
    if (RegExp(r'[0-9]').hasMatch(value)) return 'No numbers allowed';
    return null;
  }

  // Validation for Numbers Only
  String? _validateNumberOnly(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a value';
    if (RegExp(r'[a-zA-Z]').hasMatch(value)) return 'Numbers only';
    return null;
  }

  // Date picker function
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

  // Submit data to Firestore
  Future<void> _submitYieldActivity() async {
    if (_formKey.currentState?.validate() != true || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all fields and select a date.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('field_operation_records')
          .add({
        'crop': _cropController.text,
        'plot': _plotController.text,
        'activity': _activityController.text,
        'input_type': _typeController.text,
        'input_amount': _amountController.text,
        'date': Timestamp.fromDate(_selectedDate!),
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Field operation activity added successfully!')),
      );
      _clearFields();
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  // Clear input fields
  void _clearFields() {
    _cropController.clear();
    _plotController.clear();
    _activityController.clear();
    _typeController.clear();
    _amountController.clear();
    setState(() {
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Field Operation  Activity',
              style: TextStyle(color: Colors.white)),
          backgroundColor: widget.appBarColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Date Picker
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
                  // Crop Name Input
                  _buildTextFormField(_cropController, 'Crop Name',
                      icon: Icons.local_florist, isTextOnly: true),
                  const SizedBox(height: 15),
                  // Plot No/Size Input
                  _buildTextFormField(_plotController, 'Plot No/Size',
                      icon: Icons.pin_drop, inputType: TextInputType.text),
                  const SizedBox(height: 15),
                  // Activity Input
                  _buildTextFormField(_activityController, 'Operation/Activity',
                      icon: Icons.work, isTextOnly: true),
                  const SizedBox(height: 15),
                  // Input Type (e.g., fertilizer, pesticide)
                  _buildTextFormField(_typeController, 'Input Used (Type)',
                      icon: Icons.add_circle_outline, isTextOnly: true),
                  const SizedBox(height: 15),
                  // Amount of Input Used
                  _buildTextFormField(_amountController, 'Amount Used (kg/l)',
                      icon: Icons.attach_money,
                      inputType: TextInputType.number),
                  const SizedBox(height: 20),
                  // Save Button
                  ElevatedButton(
                    onPressed: _submitYieldActivity,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      backgroundColor: widget.buttonColor,
                    ),
                    child: const Text('Save Activity',
                        style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Generic TextFormField builder
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
          borderSide: BorderSide(color: widget.formFieldBorderColor),
        ),
      ),
      validator: isTextOnly ? _validateTextOnly : _validateNumberOnly,
    );
  }
}
