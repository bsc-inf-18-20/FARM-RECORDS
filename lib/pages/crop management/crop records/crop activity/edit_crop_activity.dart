import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditCropActivity extends StatefulWidget {
  final String activityId;

  const EditCropActivity({Key? key, required this.activityId})
      : super(key: key);

  @override
  _EditCropActivityState createState() => _EditCropActivityState();
}

class _EditCropActivityState extends State<EditCropActivity> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each field
  late TextEditingController _plotNumberController;
  late TextEditingController _plotSizeController;
  late TextEditingController _cropController;
  late TextEditingController _seedTypeController;
  late TextEditingController _seedAmountController;
  late TextEditingController _fertilizerTypeController;
  late TextEditingController _fertilizerAmountController;
  late TextEditingController _sprayTypeController;
  late TextEditingController _sprayAmountController;

  late DateTime _selectedDate;

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

    _loadActivityData();
  }

  // Load activity data from Firestore
  void _loadActivityData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('crop_activities')
          .doc(widget.activityId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        _plotNumberController.text = data['plot_number'] ?? '';
        _plotSizeController.text = data['plot_size_in_hectares'] ?? '';
        _cropController.text = data['crop'] ?? '';
        _seedTypeController.text = data['seed_type'] ?? '';
        _seedAmountController.text = data['seed_amount_in_kgs'] ?? '';
        _fertilizerTypeController.text = data['fertilizer_type'] ?? '';
        _fertilizerAmountController.text =
            data['fertilizer_amount_in_kgs'] ?? '';
        _sprayTypeController.text = data['spray_type'] ?? '';
        _sprayAmountController.text = data['spray_amount_in_litres'] ?? '';
        _selectedDate = (data['date'] as Timestamp).toDate();
        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load activity data: $e')),
      );
    }
  }

  // Update activity in Firestore
  void _updateActivity() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'plot_number': _plotNumberController.text,
        'plot_size_in_hectares': _plotSizeController.text,
        'crop': _cropController.text,
        'seed_type': _seedTypeController.text,
        'seed_amount_in_kgs': _seedAmountController.text,
        'fertilizer_type': _fertilizerTypeController.text,
        'fertilizer_amount_in_kgs': _fertilizerAmountController.text,
        'spray_type': _sprayTypeController.text,
        'spray_amount_in_litres': _sprayAmountController.text,
        'date': Timestamp.fromDate(_selectedDate),
      };

      try {
        await FirebaseFirestore.instance
            .collection('crop_activities')
            .doc(widget.activityId)
            .update(updatedData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activity updated successfully.')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update activity: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Crop Activity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextFormField(
                  controller: _plotNumberController,
                  labelText: 'Plot Number',
                  keyboardType: TextInputType.number,
                  validator: _validateNumber,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  controller: _plotSizeController,
                  labelText: 'Plot Size (Hectares)',
                  keyboardType: TextInputType.number,
                  validator: _validateNumber,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  controller: _cropController,
                  labelText: 'Crop',
                  validator: _validateText,
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  controller: _seedTypeController,
                  labelText: 'Seed Type',
                  validator: _validateText,
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  controller: _seedAmountController,
                  labelText: 'Seed Amount (KG)',
                  keyboardType: TextInputType.number,
                  validator: _validateNumber,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  controller: _fertilizerTypeController,
                  labelText: 'Fertilizer Type',
                  validator: _validateText,
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  controller: _fertilizerAmountController,
                  labelText: 'Fertilizer Amount (KG)',
                  keyboardType: TextInputType.number,
                  validator: _validateNumber,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  controller: _sprayTypeController,
                  labelText: 'Spray Type',
                  validator: _validateText,
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  controller: _sprayAmountController,
                  labelText: 'Spray Amount (Litres)',
                  keyboardType: TextInputType.number,
                  validator: _validateNumber,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text('Date: ${_selectedDate.toLocal()}'),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null && pickedDate != _selectedDate) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
    );
  }

  String? _validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter valid text.';
    }
    return null;
  }

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number.';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number.';
    }
    return null;
  }
}
