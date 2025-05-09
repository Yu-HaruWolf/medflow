import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <- 追加
import 'package:solution_challenge_tcu_2025/app_state.dart';
import 'package:solution_challenge_tcu_2025/ui/login_page.dart';
import 'package:solution_challenge_tcu_2025/ui/patient_page.dart';
import 'package:solution_challenge_tcu_2025/ui/personal_page.dart';
import 'package:solution_challenge_tcu_2025/firebase_options.dart';
import 'package:solution_challenge_tcu_2025/gemini/gemini_service.dart';
import 'package:solution_challenge_tcu_2025/ui/gemini_nursing_plan_page.dart';
import 'package:solution_challenge_tcu_2025/ui/nursing_plan_page.dart';
import 'package:solution_challenge_tcu_2025/ui/nursing_info_page.dart';
import 'package:solution_challenge_tcu_2025/ui/gemini_soap_page.dart';

import 'data/patient_repository.dart';
import 'data/patient.dart' as PatientData;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApplicationState()),
        ChangeNotifierProvider(create: (_) => FirebaseAuthState()),
      ],
      builder: ((context, child) => const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'MedFlow', home: SplashScreen());
  }
}

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

    Widget insideWidget;
    switch (appState.screenId) {
      case 0:
        insideWidget = LoginPage();
        break;
      case 1:
        insideWidget = const PatientPage();
        break;
      case 2:
        insideWidget = const PersonalPage();
        break;
      case 3:
        insideWidget = const NursingPlanPage();
        break;
      case 4:
        insideWidget = const NursingInfoPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      appBar:
          appState.screenId == 0 || appState.screenId == 1
              ? AppBar(
                backgroundColor: const Color.fromARGB(255, 62, 183, 220),
                centerTitle: true,
                title: Text(widget.title),
              )
              : null,
      body: Center(
        // ← ここが重要！
        child: insideWidget,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 15, 92, 118),
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                // サインアウト処理
                context.read<ApplicationState>().screenId = 0;
                Navigator.of(context).pop(); // Drawerを閉じる
              },
            ),
            // 必要なら他のメニューもここに追加可能
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ApplicationState>().screenId = 1;
        },
        tooltip: 'Go to Patient',
        child: const Icon(Icons.navigate_next), // アイコンを "次へ" のイメージに変更
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late GeminiService gemini; // ✅ インスタンスを持つようにする

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    context.read<FirebaseAuthState>().firebaseAuthListenerInit();
    print('Firebase Ready!');

    gemini = GeminiService();
    await gemini.geminiInit(); // ✅ モデル初期化
    await gemini.geminiInit2();
    // ✅ 初期化後にホームへ渡す
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MyHomePage(title: 'MEdFlow', gemini: gemini),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 92, 118),
        title: Text('Loading'),
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
