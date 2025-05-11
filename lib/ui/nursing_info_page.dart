import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge_tcu_2025/app_state.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';
import 'package:solution_challenge_tcu_2025/data/soap.dart';

class NursingInfoPage extends StatefulWidget {
  NursingInfoPage({super.key, required this.patientId});

  String patientId;

  @override
  _NursingInfoPageState createState() => _NursingInfoPageState();
}

class _NursingInfoPageState extends State<NursingInfoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Patient? patient;

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
    setState(() {
      patient = patient;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 62, 183, 220),
        title: const Text('Nursing Information'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'doctor'),
            Tab(text: 'nurse'),
            Tab(text: 'inspection'),
          ],
        ),
      ),
      body:
          patient == null
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                controller: _tabController,
                children: [
                  const Center(child: Text('Tab 1 View')),
                  NestedTabWidget(patient: patient!),
                  const Center(child: Text('Tab 3 View')),
                ],
              ),
    );
  }
}

class NestedTabWidget extends StatefulWidget {
  NestedTabWidget({super.key, required this.patient});

  Patient patient;

  @override
  State<NestedTabWidget> createState() => _NestedTabWidgetState();
}

class _NestedTabWidgetState extends State<NestedTabWidget>
    with TickerProviderStateMixin {
  late TabController _innerTabController;

  @override
  void initState() {
    super.initState();
    _innerTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _innerTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Soap> soapList = widget.patient.historyOfSoap;

    return Column(
      children: [
        TabBar(
          controller: _innerTabController,
          tabs: const [Tab(text: 'SOAP'), Tab(text: '看護計画')],
        ),
        Expanded(
          child: TabBarView(
            controller: _innerTabController,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children:
                      soapList.map((soap) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                ),
              ),
              // ----- SOAPタブの内容を表形式で -----
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
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'NANDA-I',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(widget.patient.nursingPlan.nanda_i),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              '目標',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              widget.patient.nursingPlan.goal
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
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'O-P (観察項目)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              widget.patient.nursingPlan.op
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
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'T-P (援助)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              widget.patient.nursingPlan.tp
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
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'E-P (指導)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              widget.patient.nursingPlan.ep
                                  .split('\n')
                                  .map((line) => line.trimLeft())
                                  .join('\n'),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      // 他にもSOAPに関連する情報があれば追加
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
