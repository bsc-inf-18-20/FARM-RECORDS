import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmrecord/pages/crop%20management/crop%20records/crop%20activity/crop_field_validator.dart';
import 'package:flutter/material.dart';

class CropActivityForm extends StatefulWidget {
  final Color buttonColor;
  final Color formFieldBorderColor;
  final Function(Map<String, dynamic>) onSubmit;

  const CropActivityForm({
    super.key,
    required this.buttonColor,
    required this.formFieldBorderColor,
    required this.onSubmit,
  });

  @override
  _CropActivityFormState createState() => _CropActivityFormState();
}

class _CropActivityFormState extends State<CropActivityForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _plotNumberController = TextEditingController();
  final TextEditingController _plotSizeController = TextEditingController();
  final TextEditingController _cropController = TextEditingController();
  final TextEditingController _seedTypeController = TextEditingController();
  final TextEditingController _seedAmountController = TextEditingController();
  final TextEditingController _fertilizerTypeController =
      TextEditingController();
  final TextEditingController _fertilizerAmountController =
      TextEditingController();
  final TextEditingController _sprayTypeController = TextEditingController();
  final TextEditingController _sprayAmountController = TextEditingController();
  DateTime? _selectedDate;

  final _validator = CropFieldValidator();

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
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

  void _onSubmit() {
    if (_formKey.currentState?.validate() != true || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all fields and select a date.')),
      );
      return;
    }

    final data = {
      'plot_number': _plotNumberController.text,
      'plot_size_in_hectares': _plotSizeController.text,
      'crop': _cropController.text,
      'seed_type': _seedTypeController.text,
      'seed_amount_in_kgs': _seedAmountController.text,
      'fertilizer_type': _fertilizerTypeController.text,
      'fertilizer_amount_in_kgs': _fertilizerAmountController.text,
      'spray_type': _sprayTypeController.text,
      'spray_amount_in_litres': _sprayAmountController.text,
      'date': _selectedDate,
    };

    _addActivityToFirestore(data);

    _clearFields();
  }

  // Add activity data to Firestore
  Future<void> _addActivityToFirestore(Map<String, dynamic> data) async {
    try {
      // Reference to the 'crop_activities' collection
      await FirebaseFirestore.instance.collection('crop_activities').add(data);

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Crop activity submitted successfully.')),
      );
    } catch (e) {
      // Show error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting activity: $e')),
      );
    }
  }

  void _clearFields() {
    _plotNumberController.clear();
    _plotSizeController.clear();
    _cropController.clear();
    _seedTypeController.clear();
    _seedAmountController.clear();
    _fertilizerTypeController.clear();
    _fertilizerAmountController.clear();
    _sprayTypeController.clear();
    _sprayAmountController.clear();
    setState(() {
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDateField(),
              const SizedBox(height: 15),
              _buildTextFormField(_plotNumberController, 'Plot Number',
                  Icons.pin_drop, _validator.validateNumberOnly),
              const SizedBox(height: 15),
              _buildTextFormField(_plotSizeController, 'Plot Size in hectares',
                  Icons.square_foot, _validator.validateNumberOnly),
              const SizedBox(height: 15),
              _buildTextFormField(_cropController, 'Crop', Icons.local_florist,
                  _validator.validateTextOnly),
              const SizedBox(height: 15),
              _buildTextFormField(_seedTypeController, 'Type of Seed',
                  Icons.grass, _validator.validateTextOnly),
              const SizedBox(height: 15),
              _buildTextFormField(_seedAmountController, 'Amount of Seed in kg',
                  Icons.agriculture, _validator.validateNumberOnly),
              const SizedBox(height: 15),
              _buildTextFormField(
                  _fertilizerTypeController,
                  'Fertilizer Type (e.g., manure)',
                  Icons.emoji_nature,
                  _validator.validateTextOnly),
              const SizedBox(height: 15),
              _buildTextFormField(
                  _fertilizerAmountController,
                  'Fertilizer Amount in KGs',
                  Icons.line_weight,
                  _validator.validateNumberOnly),
              const SizedBox(height: 15),
              _buildTextFormField(
                  _sprayTypeController,
                  'Spray/Insecticide Type',
                  Icons.sanitizer,
                  _validator.validateTextOnly),
              const SizedBox(height: 15),
              _buildTextFormField(
                  _sprayAmountController,
                  'Spray/Insecticide Amount litres',
                  Icons.opacity,
                  _validator.validateNumberOnly),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  backgroundColor: widget.buttonColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit Activity',
                    style: TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Select Date',
          prefixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(),
          errorText: _selectedDate == null ? 'Please choose a date' : null,
        ),
        child: Text(
          _selectedDate == null
              ? 'Choose Date'
              : '${_selectedDate!.toLocal()}'.split(' ')[0],
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String labelText,
    IconData icon,
    String? Function(String?) validator,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: widget.formFieldBorderColor)),
      ),
      validator: validator,
    );
  }
}
