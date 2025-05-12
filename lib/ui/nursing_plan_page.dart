import 'package:flutter/material.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';

class NursingPlanPage extends StatefulWidget {
  const NursingPlanPage({super.key, required this.patientId});

  final String patientId;
  @override
  _NursingPlanPageState createState() => _NursingPlanPageState();
}

class _NursingPlanPageState extends State<NursingPlanPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Patient? patient;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadPatientInfo();
  }

  void _loadPatientInfo() async {
    patient = await PatientRepository().getPatient(widget.patientId);
    setState(() {
      patient = patient;
    });
  }

  // Doctor タブ用
  final TextEditingController _doctorController = TextEditingController();
  bool _isDoctorSaved = false;
  bool get isDoctorFilled =>
      !_isDoctorSaved && _doctorController.text.isNotEmpty;

  // Nursing Plan タブ用
  final TextEditingController _sController = TextEditingController();
  final TextEditingController _oController = TextEditingController();
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _pController = TextEditingController();
  bool _isNursingPlanSaved = false;
  bool get isNursingPlanFilled =>
      !_isNursingPlanSaved &&
      (_sController.text.isNotEmpty ||
          _oController.text.isNotEmpty ||
          _aController.text.isNotEmpty ||
          _pController.text.isNotEmpty);

  // Inspection タブ用
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _hrController = TextEditingController();
  final TextEditingController _bpController = TextEditingController();
  final TextEditingController _rrController = TextEditingController();
  bool _isInspectionSaved = false;
  bool get isInspectionFilled =>
      !_isInspectionSaved &&
      (_tempController.text.isNotEmpty ||
          _hrController.text.isNotEmpty ||
          _bpController.text.isNotEmpty ||
          _rrController.text.isNotEmpty);

  @override
  void dispose() {
    _doctorController.dispose();
    _tabController.dispose();
    _sController.dispose();
    _oController.dispose();
    _aController.dispose();
    _pController.dispose();
    _tempController.dispose();
    _hrController.dispose();
    _bpController.dispose();
    _rrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          //centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 62, 183, 220),
          title: const Text(
            'Nursing Plan',
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(text: isDoctorFilled ? 'Doctor *' : 'Doctor'),
              Tab(text: 'Nurse'),
              Tab(text: isInspectionFilled ? 'Inspection *' : 'Inspection'),
            ],
            labelColor: Colors.black,
          ),
        ),
        body:
            patient == null
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                  controller: _tabController,
                  children: [
                    // Doctor タブ
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'memo',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 300,
                            child: TextField(
                              controller: _doctorController,
                              maxLines: null,
                              expands: true,
                              decoration: const InputDecoration(
                                hintText: 'Enter doctor memo...',
                                border: OutlineInputBorder(),
                              ),
                              onChanged:
                                  (_) => setState(() {
                                    _isDoctorSaved = false;
                                  }),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isDoctorSaved = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Doctor data saved'),
                                  ),
                                );
                              },
                              child: const Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    _NestedTabWidget(
                      sController: _sController,
                      oController: _oController,
                      aController: _aController,
                      pController: _pController,
                      isNursingPlanSaved: _isNursingPlanSaved,
                      onSaved: () {
                        setState(() {
                          _isNursingPlanSaved = true;
                        });
                      },
                      patient: patient!,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildVitalInput('Temperature', _tempController),
                          _buildVitalInput('Heart Rate', _hrController),
                          _buildVitalInput('Blood Pressure', _bpController),
                          _buildVitalInput('Respiratory Rate', _rrController),
                          const SizedBox(height: 20), // 少しスペース
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isInspectionSaved = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Inspection data saved'),
                                  ),
                                );
                              },
                              child: const Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildVitalInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label)),
          const SizedBox(width: 50),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
              ),
              onChanged:
                  (_) => setState(() {
                    _isInspectionSaved = false;
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class _NestedTabWidget extends StatefulWidget {
  final TextEditingController sController;
  final TextEditingController oController;
  final TextEditingController aController;
  final TextEditingController pController;
  final bool isNursingPlanSaved;
  final VoidCallback onSaved;
  final Patient patient;

  const _NestedTabWidget({
    Key? key,
    required this.sController,
    required this.oController,
    required this.aController,
    required this.pController,
    required this.isNursingPlanSaved,
    required this.onSaved,
    required this.patient,
  }) : super(key: key);

  @override
  _NestedTabWidgetState createState() => _NestedTabWidgetState();
}

class _NestedTabWidgetState extends State<_NestedTabWidget>
    with TickerProviderStateMixin {
  late TabController _innerTabController;
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _innerTabController = TabController(length: 2, vsync: this);
    _isSaved = widget.isNursingPlanSaved;
  }

  @override
  void dispose() {
    _innerTabController.dispose();
    super.dispose();
  }

  bool get isFilled =>
      !_isSaved &&
      (widget.sController.text.isNotEmpty ||
          widget.oController.text.isNotEmpty ||
          widget.aController.text.isNotEmpty ||
          widget.pController.text.isNotEmpty);

  void _handleChanged() {
    if (_isSaved) {
      setState(() {
        _isSaved = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _innerTabController,
          tabs: [Tab(text: isFilled ? 'SOAP *' : 'SOAP'), Tab(text: '看護計画')],
        ),
        Expanded(
          child: TabBarView(
            controller: _innerTabController,
            children: [_buildSOAPTab(), _buildNursingPlanTable(widget.patient)],
          ),
        ),
      ],
    );
  }

  Widget _buildSOAPTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInputField(
            'Subjective Data',
            widget.sController,
            'Enter subjective information',
          ),
          _buildInputField(
            'Objective Data',
            widget.oController,
            'Enter objective information',
          ),
          _buildInputField(
            'Assessment',
            widget.aController,
            'Enter assessment information',
          ),
          _buildInputField(
            'Plan',
            widget.pController,
            'Enter plan information',
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isSaved = true;
              });
              widget.onSaved();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('data saved')));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    String hintText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          onChanged: (_) => _handleChanged(),
          minLines: 1,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildNursingPlanTable(Patient patient) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Table(
        border: TableBorder.all(),
        columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
        children: [
          _buildTableRow('NANDA-I', patient.nursingPlan.nanda_i),
          _buildTableRow('目標', patient.nursingPlan.goal),
          _buildTableRow('O-P (観察項目)', patient.nursingPlan.op),
          _buildTableRow('T-P (援助)', patient.nursingPlan.tp),
          _buildTableRow('E-P (指導)', patient.nursingPlan.ep),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String title, String content) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            content.split('\n').map((line) => line.trimLeft()).join('\n'),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
