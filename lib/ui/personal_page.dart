import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge_tcu_2025/app_state.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';

class PersonalPage extends StatelessWidget {
  final patientId;
  const PersonalPage({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    // ダミーの診察情報リスト
    final List<String> visits = ['新しい記録を追加'];

    PatientRepository repository = PatientRepository();

    final displayDateFormat = DateFormat('yyyy/MM/dd');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 62, 183, 220),
        title: Text('Patient Information'),
      ),
      body: Center(
        child: FutureBuilder(
          future: repository.getPatient(patientId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (!snapshot.hasData) {
              return Text('No Data');
            } else {
              final patient = snapshot.data!;
              patient.historyOfSoap.forEach(
                (element) =>
                    visits.add(displayDateFormat.format(element.issueDateTime)),
              );
              return Column(
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
                                context.read<ApplicationState>().screenId =
                                    3; // ← 入力ページ
                              } else {
                                context.read<ApplicationState>().screenId =
                                    4; // ← 閲覧ページ
                              } // 3段目: 医師ID
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
                                      fontWeight:
                                          index == 0
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color:
                                          index == 0
                                              ? Colors.blue
                                              : Colors.black,
                                    ), //                         SizedBox(width: 20),
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
              );
            }
          },
        ),
      ),
    );
  }
}
