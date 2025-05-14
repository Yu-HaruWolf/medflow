import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/ui/form/nursing_plan_editor_form_page.dart';
import 'package:solution_challenge_tcu_2025/ui/form/patient_form_page.dart';
import 'package:solution_challenge_tcu_2025/ui/form/soap_form_page.dart';

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
  List<bool> _isExpandedList = []; // Add this to manage expansion state

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _loadPatientInfo();
  }

  @override
  void dispose() {
    _tabController.removeListener(
      () {},
    ); // Remove the listener to avoid memory leaks
    _tabController.dispose();
    super.dispose();
  }

  void _loadPatientInfo() async {
    patient = await PatientRepository().getPatient(widget.patientId);
    if (mounted) {
      setState(() {
        patient = patient;
        // Initialize the expansion state list based on the number of SOAPs
        _isExpandedList = List<bool>.filled(
          patient?.historyOfSoap.length ?? 0,
          false,
        );
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
                  if (_tabController.index == 2)
                    IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: 'Add SOAP',
                      onPressed: () {
                        if (patient != null) {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (_) {
                                    return SoapFormPage(patient: patient!);
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
                  if (_tabController.index != 2 ||
                      patient!.historyOfSoap.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: '患者情報を編集',
                      onPressed: () {
                        if (patient != null) {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (_) {
                                    switch (_tabController.index) {
                                      case 0:
                                        return PatientFormPage(
                                          patient: patient!,
                                        );
                                      case 1:
                                        return NursingPlanEditorFormPage(
                                          patient: patient!,
                                        );
                                      case 2:
                                        return SoapFormPage(
                                          patient: patient!,
                                          soap: patient!.historyOfSoap.last,
                                        );
                                      default:
                                        return PatientFormPage(
                                          patient: patient!,
                                        );
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
            Tab(text: 'Basic Info'),
            Tab(text: 'Nursing Plan'),
            Tab(text: 'SOAP'),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ).copyWith(top: 32.0, bottom: 64.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Personal Info Section
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Personal Info",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Table(
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(patient!.personalInfo.tel),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Health Promotion Section
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Health Promotion",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Table(
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
                                    "Pre-Hospital Course",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    patient!
                                            .healthPromotion
                                            .opinions['doctor'] ??
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    patient!
                                            .healthPromotion
                                            .opinions['family'] ??
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    patient!.healthPromotion.medicines,
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Health Manage Method",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                        // Self Perception Section
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Self Perception",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Table(
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
                                    "Self Awareness",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    patient!.selfPerception.selfAwareness,
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Worries",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(patient!.selfPerception.worries),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "How Can Help",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    patient!.selfPerception.howCanHelp,
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Pains",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(patient!.selfPerception.pains),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Others",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(patient!.selfPerception.others),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Related Contacts Section
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Related Contacts",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (patient!.relatedContacts.isNotEmpty)
                          Table(
                            border: TableBorder.all(),
                            columnWidths: const {
                              0: IntrinsicColumnWidth(),
                              1: FlexColumnWidth(),
                            },
                            children:
                                patient!.relatedContacts.map((contact) {
                                  return TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Name",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(contact.name),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Relationship",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(contact.relationship),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Tel",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(contact.tel),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          )
                        else
                          const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text("No related contacts available."),
                          ),
                      ],
                    ),
                  ),
                  // Nursing Plan Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ).copyWith(bottom: 32.0),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ).copyWith(bottom: 32.0),
                    child: Column(
                      children: [
                        // Display the latest SOAP at the top
                        if (patient!.historyOfSoap.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        _displayDateTimeFormat.format(
                                          patient!
                                              .historyOfSoap
                                              .last
                                              .issueDateTime, // Use last for the latest SOAP
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
                                        'Subject',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        patient!.historyOfSoap.last.subject,
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'Object',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        patient!.historyOfSoap.last.object,
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'Assessment',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        patient!.historyOfSoap.last.assessment,
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'Plan',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        patient!.historyOfSoap.last.plan,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        // Display previous SOAPs in an expandable list
                        if (patient!.historyOfSoap.length > 1)
                          ExpansionPanelList(
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                _isExpandedList[index] = isExpanded;
                              });
                            },
                            children:
                                patient!
                                    .historyOfSoap
                                    .reversed // Reverse the list to show newest first
                                    .skip(1) // Skip the latest SOAP
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                      final index = entry.key;
                                      final soap = entry.value;
                                      return ExpansionPanel(
                                        headerBuilder: (
                                          BuildContext context,
                                          bool isExpanded,
                                        ) {
                                          return ListTile(
                                            title: Text(
                                              _displayDateTimeFormat.format(
                                                soap.issueDateTime,
                                              ),
                                            ),
                                          );
                                        },
                                        body: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
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
                                                      'Subject',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Text(soap.subject),
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(
                                                      'Object',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Text(soap.object),
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(
                                                      'Assessment',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Text(
                                                      soap.assessment,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(
                                                      'Plan',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Text(soap.plan),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        isExpanded: _isExpandedList[index],
                                      );
                                    })
                                    .toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
