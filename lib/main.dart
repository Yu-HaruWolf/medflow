import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <- 追加
import 'package:solution_challenge_tcu_2025/app_state.dart';
import 'package:solution_challenge_tcu_2025/LoginPage.dart';
import 'package:solution_challenge_tcu_2025/Patient.dart';
import 'package:solution_challenge_tcu_2025/Personal.dart';


void main() {
    runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var appState = context.read<ApplicationState>();

    return MaterialApp(
      title: 'Nursing Efficiency',
      theme: ThemeData(
 
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 8, 77, 181)),
      ),
      home: const MyHomePage(title: 'Nursing Work Efficiency'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    
    Widget insideWidget;
    switch (appState.screenId){
      case 0:
        insideWidget = const LoginPage();
        break;
      case 1:
        insideWidget = const Patient();
        break;
      case 2:
      insideWidget = const Personal();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center( // ← ここが重要！
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
