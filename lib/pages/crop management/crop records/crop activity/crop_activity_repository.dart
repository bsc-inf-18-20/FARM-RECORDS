import 'package:cloud_firestore/cloud_firestore.dart';

class CropActivityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCropActivity(Map<String, dynamic> data) async {
    try {
      // Ensure the 'date' field is correctly formatted as a Firestore Timestamp
      if (data['date'] is DateTime) {
        // Add the activity to Firestore under the 'cropRecords' collection
        await _firestore.collection('crop_activities').add({
          ...data,
          'date': Timestamp.fromDate(
              data['date']), // Convert DateTime to Firestore Timestamp
        });
      } else {
        throw Exception('Invalid date format, expected DateTime.');
      }
    } catch (e) {
      // Handle any errors that might occur during the add operation
      throw Exception('Failed to add crop activity: $e');
    }
  }
}
