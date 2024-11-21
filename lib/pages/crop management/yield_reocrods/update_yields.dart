import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateYieldPage extends StatefulWidget {
  final String yieldId; // The ID of the yield record to be updated
  const UpdateYieldPage({required this.yieldId, super.key});

  @override
  _UpdateYieldPageState createState() => _UpdateYieldPageState();
}

class _UpdateYieldPageState extends State<UpdateYieldPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cropController;
  late TextEditingController _fieldPlotController;
  late TextEditingController _hectareController;
  late TextEditingController _yieldController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _cropController = TextEditingController();
    _fieldPlotController = TextEditingController();
    _hectareController = TextEditingController();
    _yieldController = TextEditingController();
    _selectedDate = DateTime.now(); // Default to current date

    // Load the existing yield data
    _loadYieldData();
  }

  // Load yield data for the record
  void _loadYieldData() async {
    final doc = await FirebaseFirestore.instance
        .collection('yield_records')
        .doc(widget.yieldId)
        .get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      _cropController.text = data['crop'] ?? '';
      _fieldPlotController.text = data['field_plot'] ?? '';
      _hectareController.text = data['hectares']?.toString() ?? '';
      _yieldController.text = data['yields in KGs']?.toString() ?? '';
      _selectedDate = (data['date'] as Timestamp).toDate();
      setState(() {});
    }
  }

  // Update the yield record in Firestore
  void _updateYield() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'crop': _cropController.text,
        'field_plot': _fieldPlotController.text,
        'hectares': double.tryParse(_hectareController.text),
        'yields in KGs': double.tryParse(_yieldController.text),
        'date': Timestamp.fromDate(_selectedDate),
      };

      await FirebaseFirestore.instance
          .collection('yield_records')
          .doc(widget.yieldId)
          .update(updatedData);

      // Navigate back after update
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Yield Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Crop
                _buildTextField(_cropController, 'Crop'),
                const SizedBox(height: 10),

                // Field Plot
                _buildTextField(_fieldPlotController, 'Field Plot'),
                const SizedBox(height: 10),

                // Hectares
                _buildTextField(_hectareController, 'Hectares', isNumber: true),
                const SizedBox(height: 10),

                // Yield in KGs
                _buildTextField(_yieldController, 'Yield in KGs',
                    isNumber: true),
                const SizedBox(height: 10),

                // Date Picker
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
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
