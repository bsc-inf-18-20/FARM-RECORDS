import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditLayersPage extends StatefulWidget {
  final String layerId; // The ID of the layer record to be edited

  const EditLayersPage({Key? key, required this.layerId}) : super(key: key);

  @override
  _EditLayersPageState createState() => _EditLayersPageState();
}

class _EditLayersPageState extends State<EditLayersPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _hensController;
  late TextEditingController _eggsCollectedController;
  late TextEditingController _valueInMkwController;
  late TextEditingController _feedAmountController;
  late TextEditingController _feedCostController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _hensController = TextEditingController();
    _eggsCollectedController = TextEditingController();
    _valueInMkwController = TextEditingController();
    _feedAmountController = TextEditingController();
    _feedCostController = TextEditingController();
    _selectedDate = DateTime.now();

    // Load the existing layer data
    _loadLayerData();
  }

  Future<void> _loadLayerData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('layers_records')
          .doc(widget.layerId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _hensController.text = data['Number of Hens']?.toString() ?? '';
          _eggsCollectedController.text =
              data['eggs_collected_daily']?.toString() ?? '';
          _valueInMkwController.text = data['value_in_MKW']?.toString() ?? '';
          _feedAmountController.text =
              data['feed_amount_in_kg']?.toString() ?? '';
          _feedCostController.text = data['feed_cost_in_MKW']?.toString() ?? '';
          _selectedDate = (data['date'] as Timestamp).toDate();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  Future<void> _updateLayer() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedData = {
          'Number of Hens': int.tryParse(_hensController.text),
          'eggs_collected_daily': int.tryParse(_eggsCollectedController.text),
          'value_in_MKW': double.tryParse(_valueInMkwController.text),
          'feed_amount_in_kg': double.tryParse(_feedAmountController.text),
          'feed_cost_in_MKW': double.tryParse(_feedCostController.text),
          'date': Timestamp.fromDate(_selectedDate),
        };

        await FirebaseFirestore.instance
            .collection('layers_records')
            .doc(widget.layerId)
            .update(updatedData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Layer record updated successfully')),
        );

        Navigator.pop(context); // Navigate back to the previous page
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating record: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Layer Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_hensController, 'Number of Hens', true),
                const SizedBox(height: 10),
                _buildTextField(
                    _eggsCollectedController, 'Eggs Collected Daily', true),
                const SizedBox(height: 10),
                _buildTextField(_valueInMkwController, 'Value (MKW)', true),
                const SizedBox(height: 10),
                _buildTextField(
                    _feedAmountController, 'Feed Amount (kg)', true),
                const SizedBox(height: 10),
                _buildTextField(_feedCostController, 'Feed Cost (MKW)', true),
                const SizedBox(height: 10),

                // Date Picker
                Row(
                  children: [
                    Text('Date: ${_selectedDate.toLocal()}'),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
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
                  onPressed: _updateLayer,
                  child: const Text('Update Layer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, bool isNumber) {
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
        } else if (isNumber && double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }
}
