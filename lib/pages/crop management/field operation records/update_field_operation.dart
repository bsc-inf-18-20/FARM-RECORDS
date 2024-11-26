import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateFieldOperation extends StatefulWidget {
  final String yieldId; // The ID of the yield record to be updated
  final Map<String, dynamic>? existingData; // Optional data to prefill the form

  const UpdateFieldOperation({
    required this.yieldId,
    this.existingData,
    Key? key,
  }) : super(key: key);

  @override
  _UpdateFieldOperationState createState() => _UpdateFieldOperationState();
}

class _UpdateFieldOperationState extends State<UpdateFieldOperation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _plotNumberController = TextEditingController();
  final TextEditingController _plotSizeController = TextEditingController();
  final TextEditingController _operationActivityController =
      TextEditingController();
  final TextEditingController _inputTypeController = TextEditingController();
  final TextEditingController _inputAmountController = TextEditingController();
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

  // Load existing data for the field operation
  void _loadFieldOperationData() {
    if (widget.existingData != null) {
      final data = widget.existingData!;
      _plotNumberController.text = data['plot_number'] ?? '';
      _plotSizeController.text = data['plot_size_hectares']?.toString() ?? '';
      _operationActivityController.text = data['operation_activity'] ?? '';
      _inputTypeController.text = data['input_type'] ?? '';
      _inputAmountController.text = data['input_amount_kg']?.toString() ?? '';
      _selectedDate = (data['date'] as Timestamp).toDate();
      setState(() {});
    } else {
      FirebaseFirestore.instance
          .collection('field_operations')
          .doc(widget.yieldId)
          .get()
          .then((doc) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          _plotNumberController.text = data['plot_number'] ?? '';
          _plotSizeController.text =
              data['plot_size_hectares']?.toString() ?? '';
          _operationActivityController.text = data['operation_activity'] ?? '';
          _inputTypeController.text = data['input_type'] ?? '';
          _inputAmountController.text =
              data['input_amount_kg']?.toString() ?? '';
          _selectedDate = (data['date'] as Timestamp).toDate();
          setState(() {});
        }
      });
    }
  }

  // Update the field operation record in Firestore
  void _updateFieldOperation() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final updatedData = {
        'plot_number': _plotNumberController.text,
        'plot_size_hectares': double.tryParse(_plotSizeController.text),
        'operation_activity': _operationActivityController.text,
        'input_type': _inputTypeController.text,
        'input_amount_kg': double.tryParse(_inputAmountController.text),
        'date': Timestamp.fromDate(_selectedDate!),
      };

      await FirebaseFirestore.instance
          .collection('field_operations')
          .doc(widget.yieldId)
          .update(updatedData);

      // Navigate back after update
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all fields and select a date.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFieldOperationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Field Operation Record'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Date Picker
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
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Input Fields
                _buildTextFormField(_plotNumberController, 'Plot Number',
                    Icons.pin_drop, false),
                const SizedBox(height: 15),
                _buildTextFormField(_plotSizeController, 'Plot Size (Hectares)',
                    Icons.map, false),
                const SizedBox(height: 15),
                _buildTextFormField(_operationActivityController,
                    'Operation Activity', Icons.work, true),
                const SizedBox(height: 15),
                _buildTextFormField(_inputTypeController, 'Input Type',
                    Icons.add_circle_outline, true),
                const SizedBox(height: 15),
                _buildTextFormField(_inputAmountController, 'Input Amount (Kg)',
                    Icons.attach_money, false),
                const SizedBox(height: 20),
                // Update Button
                ElevatedButton(
                  onPressed: _updateFieldOperation,
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String labelText,
      IconData icon, bool isTextOnly) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      validator: isTextOnly ? _validateTextOnly : _validateNumberOnly,
    );
  }
}
