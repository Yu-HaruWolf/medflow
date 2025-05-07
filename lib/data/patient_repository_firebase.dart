import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solution_challenge_tcu_2025/data/nursing_plan.dart';

import 'patient.dart';

class PatientRepository {
  final db = FirebaseFirestore.instance.collection('patients');

  Future<Patient?> getPatient(String id) async {
    final querySnapshot = await db.doc(id).get();
    final data = querySnapshot.data();
    if (data != null) return Patient.fromJson(data);
    return null;
  }

  Future<int> get size async {
    final aggregate = await db.count().get();
    return aggregate.count ?? 0;
  }

  Future<List<Patient>> get getAllPatients async {
    final patientList = <Patient>[];
    final querySnapshot = await db.get();
    for (var doc in querySnapshot.docs) {
      patientList.add(Patient.fromJson(doc.data()));
    }
    return patientList;
  }

  Future<void> addPatient(Patient patient) async {
    final doc = await db.add(patient.toJson());
    patient.id = doc.id;
  }

  Future<void> updatePatient(Patient updatedPatient) async {
    final doc = await db.doc(updatedPatient.id).update(updatedPatient.toJson());
  }
}
