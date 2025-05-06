import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <- 追加
import 'package:solution_challenge_tcu_2025/app_state.dart';
import 'package:solution_challenge_tcu_2025/LoginPage.dart';
import 'package:solution_challenge_tcu_2025/Patient.dart';
import 'package:solution_challenge_tcu_2025/Personal.dart';
import 'package:solution_challenge_tcu_2025/firebase_options.dart';
import 'package:solution_challenge_tcu_2025/gemini.dart';
import 'package:solution_challenge_tcu_2025/gemini_page_nursing_plan.dart';
import 'package:solution_challenge_tcu_2025/Nursing_plan.dart';
import 'package:solution_challenge_tcu_2025/Nursing_info.dart';
import 'package:solution_challenge_tcu_2025/gemini_page_soap.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: ((context, child) => const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nursing Efficiency',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 8, 77, 181),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // const MyHomePage({super.key, required this.title});

  final String title;
  final Gemini gemini; // ← これを追加する必要がある！

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

    Widget insideWidget, insideWidget1;
    switch (appState.screenId) {
      case 0:
        insideWidget = GeminiPage_nursing_plan(
          patientIndex: patientIndex,
          gemini: widget.gemini,
        );
        insideWidget1 = GeminiPage_soap(
          patientIndex: patientIndex,
          gemini: widget.gemini,
        );
        break;
      case 1:
        insideWidget = const Patient();
        break;
      case 2:
        insideWidget = const Personal();
        break;
      case 3:
        insideWidget = const Nursing_plan();
        break;
      case 4:
        insideWidget = const Nursing_info();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      appBar:
          appState.screenId == 0 || appState.screenId == 1
              ? AppBar(
                backgroundColor: const Color.fromARGB(255, 8, 77, 181),
                title: Text(widget.title),
              )
              : null,
      body: Center(
        // ← ここが重要！
        child: insideWidget,
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
  late Gemini gemini; // ✅ インスタンスを持つようにする

  @override
  void initState() {
    super.initState();
    _init();
  }

  // Future<void> _init() async {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   print('Firebase Ready!');
  //   context.read<Gemini>().geminiInit();
  //   // 初期化後にホーム画面へ
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(
  //       builder: (_) => MyHomePage(title: 'Nursing Work Efficiency'),
  //     ),
  //   );
  // }

  Future<void> _init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase Ready!');

    gemini = Gemini();
    await gemini.geminiInit(); // ✅ モデル初期化
    await gemini.geminiInit2();
    // ✅ 初期化後にホームへ渡す
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (_) => MyHomePage(title: 'Nursing Work Efficiency', gemini: gemini),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 77, 181),
        title: Text('Loading'),
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
