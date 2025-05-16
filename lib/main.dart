import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medflow/app_state.dart';
import 'package:medflow/firebase_options.dart';
import 'package:medflow/ui/top_page.dart';

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
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (mounted) {
      context.read<FirebaseAuthState>().firebaseAuthListenerInit();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => MyHomePage(title: 'MedFlow')),
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
