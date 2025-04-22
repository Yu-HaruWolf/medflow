import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge_tcu_2025/app_state.dart';

class Patient extends StatelessWidget {
  const Patient({super.key});

  @override
  Widget build(BuildContext context) {
    final patients = ['患者1','患者2','患者3','患者4'];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("患者リスト")),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context , index) {
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child:ListTile(
              title: Text(patients[index]),
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
    );
  }
}
