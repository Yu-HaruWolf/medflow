import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge_tcu_2025/app_state.dart';
import 'package:solution_challenge_tcu_2025/gemini/gemini_service.dart';
import 'package:solution_challenge_tcu_2025/ui/login_page.dart';
import 'package:solution_challenge_tcu_2025/ui/nursing_info_page.dart';
import 'package:solution_challenge_tcu_2025/ui/nursing_plan_page.dart';
import 'package:solution_challenge_tcu_2025/ui/patient_page.dart';
import 'package:solution_challenge_tcu_2025/ui/personal_page.dart';

class MyHomePage extends StatefulWidget {
  // const MyHomePage({super.key, required this.title});

  final String title;
  final GeminiService gemini; // ← これを追加する必要がある！

  const MyHomePage({required this.title, required this.gemini});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  var patientIndex = 0;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    final firebaseAuthState = context.watch<FirebaseAuthState>();

    // Widget insideWidget;
    // switch (appState.screenId) {
    //   case 0:
    //     insideWidget = firebaseAuthState.loggedIn ? TopPageMenu() : LoginPage();
    //     break;
    //   case 1:
    //     insideWidget = PatientPage();
    //     break;
    //   case 2:
    //     insideWidget = const PersonalPage();
    //     break;
    //   case 3:
    //     insideWidget = const NursingPlanPage();
    //     break;
    //   case 4:
    //     insideWidget = const NursingInfoPage();
    //     break;
    //   default:
    //     throw UnimplementedError('no widget for $selectedIndex');
    // }

    return Scaffold(
      appBar:
          appState.screenId == 0 || appState.screenId == 1
              ? AppBar(
                backgroundColor: const Color.fromARGB(255, 62, 183, 220),
                centerTitle: true,
                title: Text(widget.title),
              )
              : null,
      body: firebaseAuthState.loggedIn ? TopPageMenu() : LoginPage(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 15, 92, 118),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  if (firebaseAuthState.loggedIn)
                    Text(
                      '${FirebaseAuth.instance.currentUser?.email}',
                      style: TextStyle(color: Colors.white),
                    ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                // サインアウト処理
                FirebaseAuth.instance.signOut();
                context.read<ApplicationState>().screenId = 0;
                Navigator.of(context).pop(); // Drawerを閉じる
              },
            ),
            // 必要なら他のメニューもここに追加可能
          ],
        ),
      ),
    );
  }
}

class TopPageMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => PatientPage()));
                },
                child: const Text('Patients list'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
