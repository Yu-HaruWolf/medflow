import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge_tcu_2025/app_state.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';
import 'package:solution_challenge_tcu_2025/ui/personal_page.dart';

class PatientsListPage extends StatefulWidget {
  const PatientsListPage({super.key});

  @override
  _PatientsListPageState createState() => _PatientsListPageState();
}

class _PatientsListPageState extends State<PatientsListPage> {
  final patientRepository = PatientRepository();
  List<Patient> allPatients = [];
  List<Patient> filteredPatients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  void _loadPatients() async {
    final patients = await patientRepository.getAllPatients;
    setState(() {
      allPatients = patients;
      filteredPatients = patients;
      isLoading = false;
    });
  }

  void _filterPatients(String query) {
    setState(() {
      filteredPatients =
          allPatients
              .where((patient) => patient.personalInfo.name.contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("患者リスト")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterPatients,
              decoration: InputDecoration(
                labelText: '患者名で検索',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child:
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      itemCount: filteredPatients.length,
                      itemBuilder: (context, index) {
                        final patient = filteredPatients[index];
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            title: Text(patient.personalInfo.name),
                            subtitle: Text("なにかしらの情報"),
                            leading: Icon(Icons.person),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          PersonalPage(patientId: patient.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 新規患者追加画面遷移
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
