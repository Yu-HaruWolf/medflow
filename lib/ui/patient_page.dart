import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge_tcu_2025/app_state.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';

class PatientPage extends StatelessWidget {
  PatientPage({super.key});
  final patientRepository = PatientRepository();

  @override
  Widget build(BuildContext context) {
    final patients = patientRepository.getAllPatients;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("患者リスト")),
        body: FutureBuilder(
          future: patientRepository.getAllPatients,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Patient>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              List<Patient> patients = snapshot.data!;
              return ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(patients[index].personalInfo.name),
                      subtitle: Text("なにかしらの情報"),
                      leading: Icon(Icons.label),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        context.read<ApplicationState>().screenId = 2;
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
