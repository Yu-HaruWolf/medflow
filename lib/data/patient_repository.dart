import 'patient.dart';

class PatientRepository {
  List<Patient> patientList = List<Patient>.empty(growable: true);
  PatientRepository() {
    patientList.add(
      Patient(
        personalInfo: PersonalInfo(
          furigana: 'さんぷる',
          name: 'サンプル',
          birthday: DateTime(2000, 1, 1),
          address: 'Japan',
          tel: '00000000',
        ),
      ),
    );
  }

  Patient getPatient(int index) => patientList[index];
  int get size => patientList.length;
  List<Patient> get getAllPatients => patientList;
}
