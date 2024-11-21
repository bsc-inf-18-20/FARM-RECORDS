import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateCropActivityPage extends StatefulWidget {
  final String activityId; // The ID of the activity to be updated
  const UpdateCropActivityPage({required this.activityId, super.key});

  @override
  _UpdateCropActivityPageState createState() => _UpdateCropActivityPageState();
}

class _UpdateCropActivityPageState extends State<UpdateCropActivityPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _plotNumberController;
  late TextEditingController _plotSizeController;
  late TextEditingController _cropController;
  late TextEditingController _seedTypeController;
  late TextEditingController _seedAmountController;
  late TextEditingController _fertilizerTypeController;
  late TextEditingController _fertilizerAmountController;
  late TextEditingController _sprayTypeController;
  late TextEditingController _sprayAmountController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _plotNumberController = TextEditingController();
    _plotSizeController = TextEditingController();
    _cropController = TextEditingController();
    _seedTypeController = TextEditingController();
    _seedAmountController = TextEditingController();
    _fertilizerTypeController = TextEditingController();
    _fertilizerAmountController = TextEditingController();
    _sprayTypeController = TextEditingController();
    _sprayAmountController = TextEditingController();
    _selectedDate = DateTime.now();

    // Load the existing data from Firestore
    _loadActivityData();
  }

  void _loadActivityData() async {
    final doc = await FirebaseFirestore.instance
        .collection('crop_activities')
        .doc(widget.activityId)
        .get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      _plotNumberController.text = data['plot_number'] ?? '';
      _plotSizeController.text = data['plot_size'] ?? '';
      _cropController.text = data['crop'] ?? '';
      _seedTypeController.text = data['seed_type'] ?? '';
      _seedAmountController.text = data['seed_amount'] ?? '';
      _fertilizerTypeController.text = data['fertilizer_type'] ?? '';
      _fertilizerAmountController.text = data['fertilizer_amount'] ?? '';
      _sprayTypeController.text = data['spray_type'] ?? '';
      _sprayAmountController.text = data['spray_amount'] ?? '';
      _selectedDate = (data['date'] as Timestamp).toDate();
      setState(() {});
    }
  }

  void _updateActivity() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'plot_number': _plotNumberController.text,
        'plot_size': _plotSizeController.text,
        'crop': _cropController.text,
        'seed_type': _seedTypeController.text,
        'seed_amount': _seedAmountController.text,
        'fertilizer_type': _fertilizerTypeController.text,
        'fertilizer_amount': _fertilizerAmountController.text,
        'spray_type': _sprayTypeController.text,
        'spray_amount': _sprayAmountController.text,
        'date': Timestamp.fromDate(_selectedDate!),
      };

      await FirebaseFirestore.instance
          .collection('crop_activities')
          .doc(widget.activityId)
          .update(updatedData);

      Navigator.pop(context); // Go back after updating
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Crop Activity'),
        backgroundColor: const Color.fromARGB(255, 44, 133, 8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextFormField(
                    _plotNumberController, 'Plot Number', Icons.pin_drop),
                _buildTextFormField(_plotSizeController,
                    'Plot Size (e.g., hectares)', Icons.square_foot),
                _buildTextFormField(
                    _cropController, 'Crop', Icons.local_florist),
                _buildTextFormField(
                    _seedTypeController, 'Seed Type', Icons.grass),
                _buildTextFormField(_seedAmountController,
                    'Seed Amount (e.g., kg)', Icons.agriculture),
                _buildTextFormField(_fertilizerTypeController,
                    'Fertilizer Type', Icons.emoji_nature),
                _buildTextFormField(_fertilizerAmountController,
                    'Fertilizer Amount (e.g., kg)', Icons.line_weight),
                _buildTextFormField(
                    _sprayTypeController, 'Spray Type', Icons.sanitizer),
                _buildTextFormField(_sprayAmountController,
                    'Spray Amount (e.g., ml)', Icons.opacity),
                _buildDateField(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateActivity,
                  child: const Text('Update Activity'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 44, 133, 8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String labelText,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(),
        ),
        validator: (value) =>
            value?.isEmpty ?? true ? 'Please enter $labelText' : null,
      ),
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate!,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null && picked != _selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Select Date',
          prefixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(),
        ),
        child: Text(_selectedDate == null
            ? 'Choose Date'
            : _selectedDate!.toLocal().toString().split(' ')[0]),
      ),
    );
  }
}
