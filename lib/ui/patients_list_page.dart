import 'package:flutter/material.dart';
import 'package:medflow/data/patient.dart';
import 'package:medflow/data/patient_repository.dart';
import 'package:medflow/ui/form/patient_form_page.dart';
import 'package:medflow/ui/patient_summary_page.dart';

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
    if (mounted)
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
              .where(
                (patient) => patient.personalInfo.name.toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 62, 183, 220),
        title: Text("Patient List"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterPatients,
              decoration: InputDecoration(
                labelText: 'Search by patient name',
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
                            subtitle: Text(patient.oneLineInfo),
                            leading: Icon(Icons.person),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (_) => PatientSummaryPage(
                                        patientId: patient.id,
                                      ),
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
        onPressed: () async {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const PatientFormPage()))
              .then((_) => _loadPatients());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
