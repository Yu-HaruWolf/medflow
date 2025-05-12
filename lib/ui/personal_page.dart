import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';
import 'package:solution_challenge_tcu_2025/ui/nursing_info_page.dart';
import 'package:solution_challenge_tcu_2025/ui/nursing_plan_page.dart';

class PersonalPage extends StatefulWidget {
  final patientId;
  const PersonalPage({super.key, required this.patientId});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  Patient? _patient;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatient();
  }

  Future<void> _loadPatient() async {
    setState(() {
      _isLoading = true;
    });
    final repository = PatientRepository();
    final patient = await repository.getPatient(widget.patientId);
    setState(() {
      _patient = patient;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayDateFormat = DateFormat('yyyy/MM/dd');
    final List<String> visits = ['新しい記録を追加'];

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 62, 183, 220),
          title: Text('Patient Information'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_patient == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 62, 183, 220),
          title: Text('Patient Information'),
        ),
        body: Center(child: Text('No Data')),
      );
    }

    final patient = _patient!;
    patient.historyOfSoap.forEach(
      (element) => visits.add(displayDateFormat.format(element.issueDateTime)),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 62, 183, 220),
        title: Text('Patient Information'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // 1段目: ID と 性別
                  Row(
                    children: [
                      Text(
                        "name: ${patient.personalInfo.name}",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "furigana: ${patient.personalInfo.furigana}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // 2段目: 名前 と 生年月日
                  Row(
                    children: [
                      Text(
                        "birthday: ${patient.personalInfo.birthday != null ? displayDateFormat.format(patient.personalInfo.birthday!) : 'No data'}",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 20),
                      /*Text(
                        "生年月日: ${patient.birthDate}",
                        style: TextStyle(fontSize: 16),
                      ),*/
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: visits.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: InkWell(
                      onTap: () {
                        if (index == 0) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => NursingPlanPage(
                                patientId: widget.patientId,
                              ),
                            ),
                          );
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => NursingInfoPage(
                                patientId: widget.patientId,
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 60,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              visits[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: index == 0
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: index == 0
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
