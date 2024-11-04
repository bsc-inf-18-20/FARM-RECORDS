// // add_activity.dart
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void showAddActivityDialog(BuildContext context) {
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController cropController = TextEditingController();
//   final TextEditingController activityController = TextEditingController();
//   final TextEditingController expenditureController = TextEditingController();
//   final TextEditingController farmNameController = TextEditingController();
//   final TextEditingController incomeController = TextEditingController();

//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('Add New Activity'),
//         content: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextField(
//                 controller: dateController,
//                 decoration: const InputDecoration(labelText: 'Date'),
//               ),
//               TextField(
//                 controller: cropController,
//                 decoration: const InputDecoration(labelText: 'Crop'),
//               ),
//               TextField(
//                 controller: activityController,
//                 decoration: const InputDecoration(labelText: 'Activity'),
//               ),
//               TextField(
//                 controller: expenditureController,
//                 decoration: const InputDecoration(labelText: 'Expenditure'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: farmNameController,
//                 decoration: const InputDecoration(labelText: 'Farm Name'),
//               ),
//               TextField(
//                 controller: incomeController,
//                 decoration: const InputDecoration(labelText: 'Income'),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // Close the dialog
//             },
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               addActivityToDatabase(
//                 dateController.text,
//                 cropController.text,
//                 activityController.text,
//                 double.tryParse(expenditureController.text) ?? 0.0,
//                 farmNameController.text,
//                 double.tryParse(incomeController.text) ?? 0.0,
//               );
//               Navigator.of(context).pop(); // Close the dialog
//             },
//             child: const Text('Add Activity'),
//           ),
//         ],
//       );
//     },
//   );
// }

// // Method to add activity to Firestore
// Future<void> addActivityToDatabase(String date, String crop, String activity,
//     double expenditure, String farmName, double income) async {
//   try {
//     await FirebaseFirestore.instance.collection('activities').add({
//       'date': date,
//       'crop': crop,
//       'activity': activity,
//       'expenditure': expenditure,
//       'farmName': farmName,
//       'income': income,
//     });
//     // You can show a success message here if needed
//   } catch (e) {
//     // Handle error here (e.g., show an error message)
//     print('Failed to add activity: $e');
//   }
// }
