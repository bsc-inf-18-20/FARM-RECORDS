import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LayersActivityPage extends StatefulWidget {
  final Color appBarColor;
  final Color buttonColor;
  final Color formFieldBorderColor;

  const LayersActivityPage({
    super.key,
    this.appBarColor = Colors.green, // Default app bar color
    this.buttonColor = Colors.green, // Default button color
    this.formFieldBorderColor = Colors.grey, // Default form field border color
  });

  @override
  _LayersActivityPageState createState() => _LayersActivityPageState();
}

class _LayersActivityPageState extends State<LayersActivityPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hensController = TextEditingController();
  final TextEditingController _eggsController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _feedAmountController = TextEditingController();
  final TextEditingController _feedCostController = TextEditingController();
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

  Future<void> _submitLayersActivity() async {
    if (_formKey.currentState?.validate() != true || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all fields and select a date.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('layers_records').add({
        'Number of Hens': _hensController.text,
        'eggs_collected_daily': _eggsController.text,
        'value_in_MKW': _valueController.text,
        'feed_amount_in_kg': _feedAmountController.text,
        'feed_cost_in_MKW': _feedCostController.text,
        'date': Timestamp.fromDate(_selectedDate!),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Layers activity added successfully!')),
      );
      _clearFields();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void _clearFields() {
    _hensController.clear();
    _eggsController.clear();
    _valueController.clear();
    _feedAmountController.clear();
    _feedCostController.clear();
    setState(() {
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Layers Activity',
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
                _buildTextFormField(_hensController, 'Number of Hens',
                    icon: Icons.pets, inputType: TextInputType.number),
                const SizedBox(height: 15),
                _buildTextFormField(
                    _eggsController, 'Number of Eggs Collected Daily',
                    icon: Icons.lunch_dining, inputType: TextInputType.number),
                const SizedBox(height: 15),
                _buildTextFormField(_valueController, 'Value (MKW)',
                    icon: Icons.attach_money, inputType: TextInputType.number),
                const SizedBox(height: 15),
                _buildTextFormField(
                    _feedAmountController, 'Amount of Feed (kg)',
                    icon: Icons.kitchen, inputType: TextInputType.number),
                const SizedBox(height: 15),
                _buildTextFormField(_feedCostController, 'Cost of Feed (MKW)',
                    icon: Icons.money, inputType: TextInputType.number),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitLayersActivity,
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
