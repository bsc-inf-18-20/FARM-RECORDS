import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateFieldOperation extends StatefulWidget {
  final String yieldId; // The ID of the yield record to be updated
  const UpdateFieldOperation({required this.yieldId, Key? key})
      : super(key: key);

  @override
  _UpdateFieldOperationState createState() => _UpdateFieldOperationState();
}

class _UpdateFieldOperationState extends State<UpdateFieldOperation> {
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

  // Load existing yield data
  void _loadYieldData() async {
    final doc = await FirebaseFirestore.instance
        .collection('field_operation_records')
        .doc(widget.yieldId)
        .get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      _cropController.text = data['crop'] ?? '';
      _plotController.text = data['field_plot'] ?? '';
      _activityController.text = data['activity'] ?? '';
      _typeController.text = data['input_type'] ?? '';
      _amountController.text = data['input_amount']?.toString() ?? '';
      _selectedDate = (data['date'] as Timestamp).toDate();
      setState(() {});
    }
  }

  // Update the yield record in Firestore
  void _updateYield() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final updatedData = {
        'crop': _cropController.text,
        'field_plot': _plotController.text,
        'activity': _activityController.text,
        'input_type': _typeController.text,
        'input_amount': double.tryParse(_amountController.text),
        'date': Timestamp.fromDate(_selectedDate!),
      };

      await FirebaseFirestore.instance
          .collection('field_operation_records')
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
    _loadYieldData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Yield Record'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                    : '${_selectedDate!.toLocal()}'
                                        .split(' ')[0],
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
                              icon: Icons.pin_drop,
                              inputType: TextInputType.text),
                          const SizedBox(height: 15),

                          // Activity Input
                          _buildTextFormField(
                            _activityController,
                            'Operation/Activity',
                            icon: Icons.work,
                            isTextOnly: true,
                          ),
                          const SizedBox(height: 15),

                          // Input Type (e.g., fertilizer, pesticide)
                          _buildTextFormField(
                            _typeController,
                            'Input Used (Type)',
                            icon: Icons.add_circle_outline,
                            isTextOnly: true,
                          ),
                          const SizedBox(height: 15),

                          // Amount of Input Used
                          _buildTextFormField(
                            _amountController,
                            'Amount Used (kg/l)',
                            icon: Icons.attach_money,
                            inputType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),

                          // Update Button
                          ElevatedButton(
                            onPressed: _updateYield,
                            child: const Text('Update Yield'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
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
        border: OutlineInputBorder(),
      ),
      validator: isTextOnly ? _validateTextOnly : _validateNumberOnly,
    );
  }
}
