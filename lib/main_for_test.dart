import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge_tcu_2025/app_state.dart';
import 'package:solution_challenge_tcu_2025/data/nursing_plan.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/soap.dart';
import 'package:solution_challenge_tcu_2025/firebase_options.dart';
import 'package:solution_challenge_tcu_2025/gemini/gemini_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FirebaseAuthState())],
      builder: ((context, child) => const TestApp()),
    ),
  );
}

class TestHomePage extends StatelessWidget {
  late GeminiService gemini;
  late Patient patient;
  late NursingPlan nursingPlan;
  late Soap soap;

  TestHomePage() {
    gemini = GeminiService();
    gemini.geminiInit();
    // initialize data
    patient = _getSamplePatient();
    nursingPlan = _getSampleNursingPlan();
    soap = _getSampleSoap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            print('Button worked!');
            // print(patient.toJson());
            // NursingPlan newplan = await gemini.gemini_create_nursing_plan(
            //   patient,
            //   nursingPlan,
            //   soap,
            // );

            Soap soap = Soap(
              issueDateTime: DateTime(2024, 3, 14),
              subject: "のどがごろごろして，息苦しい時あがある",
              object: "体温37.8℃、咳をしている",
              assessment: "喉がごろごろするという発言があったため、風邪の可能性がある",
              plan: "指示に基づき，酸素吸引や医師への報告をしていく",
            );

            NursingPlan response = await gemini.gemini_create_nursing_plan(
              patient,
              nursingPlan,
              soap,
            );
            print('Nursing Plan: ${response}');
          },
          child: Text('Sample Button'),
        ),
      ),
    );
  }
}

Patient _getSamplePatient() {
  return Patient(
    id: '0',
    personalInfo: PersonalInfo(
      furigana: 'さんぷる',
      name: '怪盗キッド',
      birthday: DateTime(2000, 1, 1),
      address: 'Japan',
      tel: '00000000',
    ),
    nursingPlan: NursingPlan(
      nanda_i: "自己健康管理促進準備状態",
      goal: "退院後は一人暮らしを自身で行えるようにする",
      op: """創部の状態
床病の有無
バイタル
松葉杖の使用状態
入院中の日常生活動作
退院後、介助してくれる人がいるのか。
仕事の状況
可動域の有無
食事の状況""",
      tp: """痛みの強さの時間を確認し、緩和策を助言
退院後、電車で出社し駅から遠いため、理学療法士と協力し、リハビリ以外でも積極的に松葉杖の使用を促したり、リハビリを行ってもらう
退院後、一人暮らしのため、日常生活は自身でできるように関わる。また、家では布団で寝ついているため、自身でできないのであれば、福利用具の導入を提案する。
糖尿病があるため、栄養士と連携して食事指導を行う。""",
      ep: """痛みは夜に強くなるようなので、食後ではなく、９時１５時、２１時で飲むようにつたえる
出社するために早めに家を出るなど工夫してもらうように伝える
リハビリを行う。（具体的なメニューを書く）また、一人で起き上がれないため、初めて使用する用具の使い方を指導する。さらに、雨の日など傘がさせないため、カッパを使用してもらったする
糖尿病があると、創の回復が遅くなったり、感染など合併症になるリスクも指導して食事の指導をする。""",
    ),
  );
}

NursingPlan _getSampleNursingPlan() {
  return NursingPlan(
    nanda_i: "自己健康管理促進準備状態",
    goal: "退院後は一人暮らしを自身で行えるようにする",
    op: """創部の状態
床病の有無
バイタル
松葉杖の使用状態
入院中の日常生活動作
退院後、介助してくれる人がいるのか。
仕事の状況
可動域の有無
食事の状況""",
    tp: """痛みの強さの時間を確認し、緩和策を助言
退院後、電車で出社し駅から遠いため、理学療法士と協力し、リハビリ以外でも積極的に松葉杖の使用を促したり、リハビリを行ってもらう
退院後、一人暮らしのため、日常生活は自身でできるように関わる。また、家では布団で寝ついているため、自身でできないのであれば、福利用具の導入を提案する。
糖尿病があるため、栄養士と連携して食事指導を行う。""",
    ep: """痛みは夜に強くなるようなので、食後ではなく、９時１５時、２１時で飲むようにつたえる
出社するために早めに家を出るなど工夫してもらうように伝える
リハビリを行う。（具体的なメニューを書く）また、一人で起き上がれないため、初めて使用する用具の使い方を指導する。さらに、雨の日など傘がさせないため、カッパを使用してもらったする
糖尿病があると、創の回復が遅くなったり、感染など合併症になるリスクも指導して食事の指導をする。""",
  );
}

Soap _getSampleSoap() {
  return Soap(
    issueDateTime: DateTime(2024, 3, 14),
    subject: "のどがごろごろして，息苦しい時あがある",
    object: "体温37.8℃、咳をしている",
    assessment: "喉がごろごろするという発言があったため、風邪の可能性がある",
    plan: "指示に基づき，酸素吸引や医師への報告をしていく",
  );
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'TestApp', home: SplashScreen());
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
    context.read<FirebaseAuthState>().firebaseAuthListenerInit();
    print('Firebase Ready!');

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => TestHomePage()));
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
