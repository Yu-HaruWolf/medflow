import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge_tcu_2025/app_state.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({super.key});

  @override
  _PatientPageState createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  final List<String> patients = ['患者1', '患者2', '患者3', '患者4'];
  List<String> filteredPatients = [];

  @override
  void initState() {
    super.initState();
    // 初期状態では全ての患者を表示
    filteredPatients = patients;
  }

  void _filterPatients(String query) {
    setState(() {
      filteredPatients =
          patients.where((patient) => patient.contains(query)).toList();
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
            child: ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(filteredPatients[index]),
                    subtitle: Text("なにかしらの情報"),
                    leading: Icon(Icons.label),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      context.read<ApplicationState>().screenId = 2;
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
