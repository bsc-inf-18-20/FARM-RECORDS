import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewFieldOperationActivities extends StatelessWidget {
  final Color appBarColor;

  const ViewFieldOperationActivities(
      {super.key, this.appBarColor = Colors.teal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Field Operation Activities'),
        backgroundColor: appBarColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(
                'field_operation_records') // Update with your Firestore collection
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }

          final activities = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index].data() as Map<String, dynamic>;
              final activityId = activities[index].id; // Get document ID

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text('Crop: ${activity['crop'] ?? 'N/A'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Plot: ${activity['plot'] ?? 'N/A'}'),
                      Text('Activity: ${activity['activity'] ?? 'N/A'}'),
                      Text('Input Type: ${activity['input_type'] ?? 'N/A'}'),
                      Text('Amount: ${activity['input_amount'] ?? 'N/A'}'),
                      Text(
                          'Date: ${activity['date']?.toDate().toString() ?? 'N/A'}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit Icon
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Navigate to the UpdateFieldOperationPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateFieldOperationPage(
                                activityId: activityId,
                                existingData: activity,
                              ),
                            ),
                          );
                        },
                      ),
                      // Delete Icon
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          // Show confirmation dialog
                          bool? deleteConfirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Activity'),
                              content: const Text(
                                  'Are you sure you want to delete this activity?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (deleteConfirmed ?? false) {
                            // Delete the activity
                            await FirebaseFirestore.instance
                                .collection('field_operation_records')
                                .doc(activityId)
                                .delete();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Activity deleted successfully'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// UpdateFieldOperationPage: Implement the edit functionality here
class UpdateFieldOperationPage extends StatefulWidget {
  final String activityId;
  final Map<String, dynamic> existingData;

  const UpdateFieldOperationPage({
    required this.activityId,
    required this.existingData,
    super.key,
  });

  @override
  _UpdateFieldOperationPageState createState() =>
      _UpdateFieldOperationPageState();
}

class _UpdateFieldOperationPageState extends State<UpdateFieldOperationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cropController = TextEditingController();
  final TextEditingController _plotController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _cropController.text = widget.existingData['crop'] ?? '';
    _plotController.text = widget.existingData['plot'] ?? '';
    _activityController.text = widget.existingData['activity'] ?? '';
    _typeController.text = widget.existingData['input_type'] ?? '';
    _amountController.text = widget.existingData['input_amount'] ?? '';
    _selectedDate = (widget.existingData['date'] as Timestamp?)?.toDate();
  }

  // Submit the updated data
  Future<void> _submitUpdatedData() async {
    if (_formKey.currentState?.validate() != true || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all fields and select a date.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('field_operation_records')
          .doc(widget.activityId)
          .update({
        'crop': _cropController.text,
        'plot': _plotController.text,
        'activity': _activityController.text,
        'input_type': _typeController.text,
        'input_amount': _amountController.text,
        'date': Timestamp.fromDate(_selectedDate!),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activity updated successfully!')),
      );
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  // Date picker function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Field Operation Activity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                // Crop Name Input
                _buildTextFormField(_cropController, 'Crop Name'),
                const SizedBox(height: 15),
                // Plot No/Size Input
                _buildTextFormField(_plotController, 'Plot No/Size'),
                const SizedBox(height: 15),
                // Activity Input
                _buildTextFormField(_activityController, 'Operation/Activity'),
                const SizedBox(height: 15),
                // Input Type (e.g., fertilizer, pesticide)
                _buildTextFormField(_typeController, 'Input Used (Type)'),
                const SizedBox(height: 15),
                // Amount of Input Used
                _buildTextFormField(_amountController, 'Amount Used (kg/l)',
                    inputType: TextInputType.number),
                const SizedBox(height: 20),
                // Save Button
                ElevatedButton(
                  onPressed: _submitUpdatedData,
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String labelText,
      {TextInputType inputType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}
