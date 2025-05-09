import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge_tcu_2025/app_state.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';


class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {

    // ダミーの診察情報リスト
    final List<String> visits = [
      '新しい記録を追加',
      '2024/03/15',
      '2024/03/14',
      '2024/03/13',
      '2023/03/12',
    ];

    PatientRepository repository = PatientRepository();
    Patient patient = PatientRepository().patientList[0];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              context.read<ApplicationState>().screenId = 1;
              ;
            },
          ),
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
                          "birthday: ${patient.personalInfo.birthday}",
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
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                      index == 0 ? Colors.blue : Colors.black,
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
          ),
        ),
      ),
    );
  }
}
