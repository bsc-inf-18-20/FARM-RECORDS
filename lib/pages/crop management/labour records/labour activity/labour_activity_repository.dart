import 'package:cloud_firestore/cloud_firestore.dart';

class LabourActivityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addLabourActivity(Map<String, dynamic> data) async {
    await _firestore.collection('labour_records').add({
      ...data,
      'date': Timestamp.fromDate(data['date']),
    });
  }
}
