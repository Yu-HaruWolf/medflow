import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <- 追加
import 'package:solution_challenge_tcu_2025/app_state.dart';
import 'package:solution_challenge_tcu_2025/firebase_options.dart';
import 'package:solution_challenge_tcu_2025/gemini/gemini_service.dart';
import 'package:solution_challenge_tcu_2025/ui/top_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FirebaseAuthState())],
      builder: ((context, child) => const MedFlowApp()),
    ),
  );
}

class MedFlowApp extends StatelessWidget {
  const MedFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'MedFlow', home: SplashScreen());
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
    gemini.geminiInit(); // ✅ モデル初期化
    // ✅ 初期化後にホームへ渡す
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MyHomePage(title: 'MedFlow', gemini: gemini),
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
