import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YieldActivityPage extends StatefulWidget {
  final Color appBarColor;
  final Color buttonColor;
  final Color formFieldBorderColor;

  const YieldActivityPage({
    super.key,
    this.appBarColor = Colors.teal, // Default app bar color
    this.buttonColor = Colors.teal, // Default button color
    this.formFieldBorderColor = Colors.grey, // Default form field border color
  });

  @override
  // ignore: library_private_types_in_public_api
  _YieldActivityPageState createState() => _YieldActivityPageState();
}

class _YieldActivityPageState extends State<YieldActivityPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cropController = TextEditingController();
  final TextEditingController _fieldController = TextEditingController();
  final TextEditingController _hectareController = TextEditingController();
  final TextEditingController _yieldController = TextEditingController();
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

  Future<void> _submitYieldActivity() async {
    if (_formKey.currentState?.validate() != true || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all fields and select a date.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('yield_records').add({
        'crop': _cropController.text,
        'field_plot': _fieldController.text,
        'hectares': _hectareController.text,
        'yields in KGs': _yieldController.text,
        'date': Timestamp.fromDate(_selectedDate!),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yield activity added successfully!')),
      );
      _clearFields();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void _clearFields() {
    _cropController.clear();
    _fieldController.clear();
    _hectareController.clear();
    _yieldController.clear();
    setState(() {
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Yield Activity',
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
                _buildTextFormField(_cropController, 'Crop',
                    icon: Icons.local_florist, isTextOnly: true),
                const SizedBox(height: 15),
                _buildTextFormField(_fieldController, 'Field or Plot',
                    icon: Icons.pin_drop, isTextOnly: true),
                const SizedBox(height: 15),
                _buildTextFormField(_hectareController, 'Hectares',
                    icon: Icons.square_foot, inputType: TextInputType.number),
                const SizedBox(height: 15),
                _buildTextFormField(_yieldController, 'Yield',
                    icon: Icons.show_chart, inputType: TextInputType.number),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitYieldActivity,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    backgroundColor: widget.buttonColor,
                  ),
                  child: const Text(
                    'Save Activity',
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
