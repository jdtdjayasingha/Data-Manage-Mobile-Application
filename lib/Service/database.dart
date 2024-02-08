import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Future addStudentDetails(
      Map<String, dynamic> studentInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Student")
        .doc(id)
        .set(studentInfoMap);
  }
}
