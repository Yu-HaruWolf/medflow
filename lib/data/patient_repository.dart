import 'package:solution_challenge_tcu_2025/data/nursing_plan.dart';
import 'package:solution_challenge_tcu_2025/data/soap.dart';

import 'patient.dart';
import 'soap.dart';

class PatientRepository {
  static List<Patient> patientList = [
    Patient(
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
        tp: """ 痛みの強さの時間を確認し、緩和策を助言
                  退院後、電車で出社し駅から遠いため、理学療法士と協力し、リハビリ以外でも積極的に松葉杖の使用を促したり、リハビリを行ってもらう
                  退院後、一人暮らしのため、日常生活は自身でできるように関わる。また、家では布団で寝ついているため、自身でできないのであれば、福利用具の導入を提案する。
                  糖尿病があるため、栄養士と連携して食事指導を行う。""",
        ep: """ 痛みは夜に強くなるようなので、食後ではなく、９時１５時、２１時で飲むようにつたえる
                  出社するために早めに家を出るなど工夫してもらうように伝える
                  リハビリを行う。（具体的なメニューを書く）また、一人で起き上がれないため、初めて使用する用具の使い方を指導する。さらに、雨の日など傘がさせないため、カッパを使用してもらったする
                  糖尿病があると、創の回復が遅くなったり、感染など合併症になるリスクも指導して食事の指導をする。""",
      ),
      historyOfSoap: [
        Soap(
          issueDateTime: DateTime(2024, 3, 14),
          subject: "のどがごろごろして，息苦しい時あがある",
          object: "体温37.8℃、咳をしている",
          assessment: "喉がごろごろするという発言があったため、風邪の可能性がある",
          plan: "指示に基づき，酸素吸引や医師への報告をしていく",
        ),
      ],
    ),
  ];
  PatientRepository() {}

  Future<Patient?> getPatient(String id) async {
    print('getPatient called');
    await Future.delayed(Duration(seconds: 2));
    try {
      return patientList[int.parse(id)];
    } catch (e) {
      return null;
    }
  }

  Future<int> get size async => patientList.length;
  Future<List<Patient>> get getAllPatients async {
    await Future.delayed(Duration(seconds: 2));
    print('getAllPatients called.');
    return patientList;
  }

  Future<void> addPatient(Patient patient) async {
    patientList.add(patient);
    patient.id = (await size - 1).toString();
    await Future.delayed(Duration(seconds: 2));
  }

  Future<void> updatePatient(Patient updatedPatient) async {
    patientList[int.parse(updatedPatient.id)] = updatedPatient;
    await Future.delayed(Duration(seconds: 2));
  }
}
