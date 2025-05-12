import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/soap.dart';
import 'package:solution_challenge_tcu_2025/ui/edit_nursing_plan_page.dart';
import 'package:solution_challenge_tcu_2025/ui/edit_soap_page.dart';
import 'package:solution_challenge_tcu_2025/ui/personal_page.dart';
import 'package:solution_challenge_tcu_2025/ui/edit_patient_page.dart';

class PatientSummaryPage extends StatefulWidget {
  final String patientId;
  const PatientSummaryPage({super.key, required this.patientId});

  @override
  _PatientSummaryPageState createState() => _PatientSummaryPageState();
}

class _PatientSummaryPageState extends State<PatientSummaryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Patient? patient;
  final _displayDateFormat = DateFormat('yyyy/MM/dd');
  final _displayDateTimeFormat = DateFormat('yyyy/MM/dd HH:mm:ss');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadPatientInfo();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadPatientInfo() async {
    patient = await PatientRepository().getPatient(widget.patientId);
    if (mounted) {
      setState(() {
        patient = patient;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 62, 183, 220),
        title: const Text('Patient Summary'),
        actions:
            patient ==
                    null // Check if patient data is loaded
                ? null // Do not show button if patient data is not loaded
                : <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: '患者情報を編集',
                    onPressed: () {
                      print(_tabController.index);
                      if (patient != null) {
                        // Ensure patient is not null before navigating
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (_) {
                                  switch (_tabController.index) {
                                    case 0:
                                      return EditPatientPage(patient: patient!);
                                    case 1:
                                      return EditNursingPlanPage(
                                        patient: patient!,
                                      );
                                    case 2:
                                      return EditSoapPage(
                                        patient: patient!,
                                        soap: patient!.historyOfSoap.last,
                                      ); // TODO: lastでよいか確認
                                    default:
                                      return EditPatientPage(patient: patient!);
                                  }
                                },
                              ),
                            )
                            .then((_) {
                              // Refresh data after returning from edit page
                              _loadPatientInfo();
                            });
                      }
                    },
                  ),
                ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Nursing Database'),
            Tab(text: 'Nursing Plan'),
            Tab(text: 'Latest SOAP'),
          ],
        ),
      ),
      body:
          patient == null
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                controller: _tabController,
                children: [
                  // Nursing Database Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: IntrinsicColumnWidth(),
                        1: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Name",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(patient!.personalInfo.name),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Furigana",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(patient!.personalInfo.furigana),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Birthday",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                patient!.personalInfo.birthday != null
                                    ? _displayDateFormat.format(
                                      patient!.personalInfo.birthday!,
                                    )
                                    : 'No data',
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Address",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(patient!.personalInfo.address),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Tel",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(patient!.personalInfo.tel),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Pre-Hospital Course",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                patient!.healthPromotion.preHospitalCourse,
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Chief Complaint",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                patient!.healthPromotion.chiefComplaint,
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Purpose",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(patient!.healthPromotion.purpose),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Doctor's Opinion",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                patient!.healthPromotion.opinions['doctor'] ??
                                    'No data',
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Principal's Opinion",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                patient!
                                        .healthPromotion
                                        .opinions['principal'] ??
                                    'No data',
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Family's Opinion",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                patient!.healthPromotion.opinions['family'] ??
                                    'No data',
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Past Medical History",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                patient!.healthPromotion.pastMedicalHistory,
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Medicines",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(patient!.healthPromotion.medicines),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Health Manage Method",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                patient!.healthPromotion.healthManageMethod,
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Alcohol Per Day",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                patient!.healthPromotion.alcoholPerDay
                                        ?.toString() ??
                                    'No data',
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Cigarettes Per Day",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                patient!.healthPromotion.cigarettsPerDay
                                        ?.toString() ??
                                    'No data',
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Other Substance",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                patient!.healthPromotion.otherSubstance,
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Other Substance Related Info",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                patient!
                                    .healthPromotion
                                    .otherSubstanceRelatedInfo,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Nursing Plan Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: const {
                          0: IntrinsicColumnWidth(),
                          1: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "Date of Issue",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  _displayDateTimeFormat.format(
                                    patient!.nursingPlan.issueDateTime,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "NANDA-I",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(patient!.nursingPlan.nanda_i),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "Goal",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  patient!.nursingPlan.goal
                                      .split('\n')
                                      .map((line) => line.trimLeft())
                                      .join('\n'),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "O-P (Observation)",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  patient!.nursingPlan.op
                                      .split('\n')
                                      .map((line) => line.trimLeft())
                                      .join('\n'),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "T-P (Assistance)",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  patient!.nursingPlan.tp
                                      .split('\n')
                                      .map((line) => line.trimLeft())
                                      .join('\n'),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "E-P (Guidance)",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  patient!.nursingPlan.ep
                                      .split('\n')
                                      .map((line) => line.trimLeft())
                                      .join('\n'),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Latest SOAP Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        ...patient!.historyOfSoap.map((soap) {
                          // Spread the list of widgets
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ), // Reduced vertical padding for compactness
                            child: Table(
                              border: TableBorder.all(),
                              columnWidths: const {
                                0: IntrinsicColumnWidth(),
                                1: FlexColumnWidth(),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'S',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(soap.subject),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'O',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(soap.object),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'A',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(soap.assessment),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'P',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(soap.plan),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        // Add the button here
                        if (patient!
                            .historyOfSoap
                            .isNotEmpty) // Optionally show button only if there's history
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => PersonalPage(
                                          patientId: widget.patientId,
                                        ),
                                  ),
                                );
                              },
                              child: const Text(
                                "Previous SOAP",
                              ), // Clarified button text
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
