import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FieldOperationPage extends StatefulWidget {
  final Color appBarColor;
  final Color buttonColor;
  final Color formFieldBorderColor;

  const FieldOperationPage({
    super.key,
    this.appBarColor =
        const Color.fromARGB(255, 44, 133, 8), // Default app bar color
    this.buttonColor =
        const Color.fromARGB(255, 44, 133, 8), // Default button color
    this.formFieldBorderColor = Colors.grey, // Default form field border color
  });

  @override
  _FieldOperationPageState createState() => _FieldOperationPageState();
}

class _FieldOperationPageState extends State<FieldOperationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _plotNumberController = TextEditingController();
  final TextEditingController _plotSizeController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _inputTypeController = TextEditingController();
  final TextEditingController _inputAmountController = TextEditingController();
  DateTime? _selectedDate;

  String? _validateTextOnly(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a value';
    if (RegExp(r'[0-9]').hasMatch(value)) return 'No numbers allowed';
    return null;
  }

  String? _validateNumberOnly(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a value';
    if (RegExp(r'[a-zA-Z]').hasMatch(value)) return 'Numbers only';
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

  Future<void> _submitFieldOperation() async {
    if (_formKey.currentState?.validate() != true || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all fields and select a date.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('field_operations').add({
        'date': Timestamp.fromDate(_selectedDate!),
        'plot_number': _plotNumberController.text,
        'plot_size_hectares': _plotSizeController.text,
        'operation_activity': _activityController.text,
        'input_type': _inputTypeController.text,
        'input_amount_kg': _inputAmountController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Field operation added successfully!')),
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
    _activityController.clear();
    _inputTypeController.clear();
    _inputAmountController.clear();
    setState(() {
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Field Operation',
          style: TextStyle(color: Colors.white),
        ),
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
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Select Date',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                      errorText:
                          _selectedDate == null ? 'Please choose a date' : null,
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
                    icon: Icons.numbers, isTextOnly: false),
                const SizedBox(height: 15),
                _buildTextFormField(
                    _plotSizeController, 'Plot Size in Hectares',
                    icon: Icons.square_foot, isTextOnly: false),
                const SizedBox(height: 15),
                _buildTextFormField(_activityController, 'Operation/Activity',
                    icon: Icons.work, isTextOnly: true),
                const SizedBox(height: 15),
                _buildTextFormField(_inputTypeController, 'Input Type',
                    icon: Icons.category, isTextOnly: true),
                const SizedBox(height: 15),
                _buildTextFormField(
                    _inputAmountController, 'Input Amount Used in KGs',
                    icon: Icons.scale, isTextOnly: false),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitFieldOperation,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    backgroundColor: widget.buttonColor,
                  ),
                  child: const Text(
                    'Save Operation',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
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
      keyboardType: isTextOnly ? TextInputType.text : TextInputType.number,
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
