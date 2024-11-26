// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';

// class UpdateCropRecords extends StatefulWidget {
//   final String activityId; // The ID of the activity to be updated

//   const UpdateCropRecords({required this.activityId, super.key});

//   @override
//   _UpdateCropRecordsState createState() => _UpdateCropRecordsState();
// }

// class _UpdateCropRecordsState extends State<UpdateCropRecords> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers for each form field
//   late TextEditingController _plotNumberController;
//   late TextEditingController _plotSizeController;
//   late TextEditingController _cropController;
//   late TextEditingController _seedTypeController;
//   late TextEditingController _seedAmountController;
//   late TextEditingController _fertilizerTypeController;
//   late TextEditingController _fertilizerAmountController;
//   late TextEditingController _sprayTypeController;
//   late TextEditingController _sprayAmountController;

//   late DateTime _selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     _plotNumberController = TextEditingController();
//     _plotSizeController = TextEditingController();
//     _cropController = TextEditingController();
//     _seedTypeController = TextEditingController();
//     _seedAmountController = TextEditingController();
//     _fertilizerTypeController = TextEditingController();
//     _fertilizerAmountController = TextEditingController();
//     _sprayTypeController = TextEditingController();
//     _sprayAmountController = TextEditingController();
//     _selectedDate = DateTime.now(); // Default to current date

//     // Load the existing data from Firestore
//     _loadActivityData();
//   }

//   // Load data for the activity
//   void _loadActivityData() async {
//     final doc = await FirebaseFirestore.instance
//         .collection('crop_activities')
//         .doc(widget.activityId)
//         .get();

//     if (doc.exists) {
//       final data = doc.data() as Map<String, dynamic>;
//       _plotNumberController.text = data['plot_number'] ?? '';
//       _plotSizeController.text = data['plot_size'] ?? '';
//       _cropController.text = data['crop'] ?? '';
//       _seedTypeController.text = data['seed_type'] ?? '';
//       _seedAmountController.text = data['seed_amount'] ?? '';
//       _fertilizerTypeController.text = data['fertilizer_type'] ?? '';
//       _fertilizerAmountController.text = data['fertilizer_amount'] ?? '';
//       _sprayTypeController.text = data['spray_type'] ?? '';
//       _sprayAmountController.text = data['spray_amount'] ?? '';
//       _selectedDate = (data['date'] as Timestamp).toDate();
//       setState(() {});
//     }
//   }

//   // Update the activity in Firestore
//   void _updateActivity() async {
//     if (_formKey.currentState!.validate()) {
//       final updatedData = {
//         'plot_number': _plotNumberController.text,
//         'plot_size': _plotSizeController.text,
//         'crop': _cropController.text,
//         'seed_type': _seedTypeController.text,
//         'seed_amount': _seedAmountController.text,
//         'fertilizer_type': _fertilizerTypeController.text,
//         'fertilizer_amount': _fertilizerAmountController.text,
//         'spray_type': _sprayTypeController.text,
//         'spray_amount': _sprayAmountController.text,
//         'date': Timestamp.fromDate(_selectedDate),
//       };

//       await FirebaseFirestore.instance
//           .collection('crop_activities')
//           .doc(widget.activityId)
//           .update(updatedData);

//       // Go back to the previous screen after update
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Update Crop Activity'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Plot Number (Numbers only)
//                 _buildTextFormField(
//                   controller: _plotNumberController,
//                   labelText: 'Plot Number',
//                   keyboardType: TextInputType.number,
//                   validator: _validateNumber,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 ),
//                 const SizedBox(height: 10),

//                 // Plot Size (Numbers only)
//                 _buildTextFormField(
//                   controller: _plotSizeController,
//                   labelText: 'Plot Size (e.g., hectares)',
//                   keyboardType: TextInputType.number,
//                   validator: _validateNumber,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 ),
//                 const SizedBox(height: 10),

//                 // Crop (Text only)
//                 _buildTextFormField(
//                   controller: _cropController,
//                   labelText: 'Crop',
//                   validator: _validateText,
//                 ),
//                 const SizedBox(height: 10),

//                 // Type of Seed (Text only)
//                 _buildTextFormField(
//                   controller: _seedTypeController,
//                   labelText: 'Type of Seed',
//                   validator: _validateText,
//                 ),
//                 const SizedBox(height: 10),

//                 // Amount of Seed (Numbers only)
//                 _buildTextFormField(
//                   controller: _seedAmountController,
//                   labelText: 'Amount of Seed (e.g., kg)',
//                   keyboardType: TextInputType.number,
//                   validator: _validateNumber,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 ),
//                 const SizedBox(height: 10),

//                 // Fertilizer Type (Text only)
//                 _buildTextFormField(
//                   controller: _fertilizerTypeController,
//                   labelText: 'Fertilizer Type',
//                   validator: _validateText,
//                 ),
//                 const SizedBox(height: 10),

//                 // Fertilizer Amount (Numbers only)
//                 _buildTextFormField(
//                   controller: _fertilizerAmountController,
//                   labelText: 'Fertilizer Amount (e.g., kg)',
//                   keyboardType: TextInputType.number,
//                   validator: _validateNumber,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 ),
//                 const SizedBox(height: 10),

//                 // Spray Type (Text only)
//                 _buildTextFormField(
//                   controller: _sprayTypeController,
//                   labelText: 'Spray/Insecticide Type',
//                   validator: _validateText,
//                 ),
//                 const SizedBox(height: 10),

//                 // Spray Amount (Numbers only)
//                 _buildTextFormField(
//                   controller: _sprayAmountController,
//                   labelText: 'Spray/Insecticide Amount (e.g., ml)',
//                   keyboardType: TextInputType.number,
//                   validator: _validateNumber,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 ),
//                 const SizedBox(height: 10),

//                 // Date Picker
//                 Row(
//                   children: [
//                     Text('Date: ${_selectedDate.toLocal()}'),
//                     IconButton(
//                       icon: const Icon(Icons.calendar_today),
//                       onPressed: () async {
//                         DateTime? picked = await showDatePicker(
//                           context: context,
//                           initialDate: _selectedDate,
//                           firstDate: DateTime(2000),
//                           lastDate: DateTime(2101),
//                         );
//                         if (picked != null && picked != _selectedDate) {
//                           setState(() {
//                             _selectedDate = picked;
//                           });
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),

//                 // Update Button
//                 ElevatedButton(
//                   onPressed: _updateActivity,
//                   child: const Text('Update Activity'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextFormField({
//     required TextEditingController controller,
//     required String labelText,
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//     List<TextInputFormatter>? inputFormatters,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: labelText,
//         border: OutlineInputBorder(),
//       ),
//       keyboardType: keyboardType,
//       inputFormatters: inputFormatters,
//       validator: validator,
//     );
//   }

//   // Helper validators
//   String? _validateText(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter valid text';
//     }
//     if (RegExp(r'[0-9]').hasMatch(value)) {
//       return 'Please enter text only, no numbers allowed';
//     }
//     return null;
//   }

//   String? _validateNumber(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter a number';
//     }
//     if (RegExp(r'[a-zA-Z]').hasMatch(value)) {
//       return 'Please enter numbers only, no letters allowed';
//     }
//     return null;
//   }
// }
