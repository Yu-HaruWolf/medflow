import 'nursing_plan.dart';
import 'soap.dart';

class Patient {
  Patient({
    this.relatedContacts = const [],
    PersonalInfo? personalInfo,
    HealthPromotion? healthPromotion,
    Nutrition? nutrition,
    EliminationAndExchange? eliminationAndExchange,
    ActivityAndRest? activityAndRest,
    PerceptionAndCognition? perceptionAndCognition,
    SelfPerception? selfPerception,
    Relationship? relationship,
    Sexuality? sexuality,
    Coping? coping,
    LifePrinciples? lifePrinciples,
    Safety? safety,
    Comfort? comfort,
    Growth? growth,
    NursingPlan? nursingPlan,
    this.historyOfSoap = const [],
  }) : personalInfo = personalInfo ?? PersonalInfo(),
       healthPromotion = healthPromotion ?? HealthPromotion(),
       nutrition = nutrition ?? Nutrition(),
       eliminationAndExchange =
           eliminationAndExchange ?? EliminationAndExchange(),
       activityAndRest = activityAndRest ?? ActivityAndRest(),
       perceptionAndCognition =
           perceptionAndCognition ?? PerceptionAndCognition(),
       selfPerception = selfPerception ?? SelfPerception(),
       relationship = relationship ?? Relationship(),
       sexuality = sexuality ?? Sexuality(),
       coping = coping ?? Coping(),
       lifePrinciples = lifePrinciples ?? LifePrinciples(),
       safety = safety ?? Safety(),
       comfort = comfort ?? Comfort(),
       growth = growth ?? Growth(),
       nursingPlan = nursingPlan ?? NursingPlan();

  PersonalInfo personalInfo;
  List<RelatedContact> relatedContacts;
  HealthPromotion healthPromotion;
  Nutrition nutrition;
  EliminationAndExchange eliminationAndExchange;
  ActivityAndRest activityAndRest;
  PerceptionAndCognition perceptionAndCognition;
  SelfPerception selfPerception;
  Relationship relationship;
  Sexuality sexuality;
  Coping coping;
  LifePrinciples lifePrinciples;
  Safety safety;
  Comfort comfort;
  Growth growth;

  List<Soap> historyOfSoap;
  NursingPlan nursingPlan;
}

class PersonalInfo {
  PersonalInfo({
    this.furigana = "",
    this.name = "",
    this.birthday,
    this.address = "",
    this.tel = "",
  });
  String furigana;
  String name;
  DateTime? birthday;
  String address;
  String tel;
}

class RelatedContact {
  RelatedContact({this.name = "", this.relationship = "", this.tel = ""});

  String name;
  String relationship; // 続柄
  String tel;
}

class HealthPromotion {
  HealthPromotion({
    this.preHospitalCourse = "",
    this.chiefComplaint = "",
    this.purpose = "",
    this.opinions = const {"doctor": "", "principal": "", "family": ""},
    this.pastMedicalHistory = "",
    this.isMedicinesExist,
    this.medicines = "",
    this.isHealthManageMethodExist,
    this.healthManageMethod = "",
    this.isSubstanceExist,
    this.alcoholPerDay = 0,
    this.cigarettsPerDay = 0,
    this.otherSubstance = "",
    this.otherSubstanceRelatedInfo = "",
  });
  String preHospitalCourse; // 入院までの経過
  String chiefComplaint; // 主訴
  String purpose; // 入院目的
  Map<String, String> opinions; // 現在の病気について医師からの説明とそのとらえ方
  String pastMedicalHistory; // 既往歴
  bool? isMedicinesExist; // 入院までの使用薬剤の有無
  String medicines; // 入院までの使用薬剤
  bool? isHealthManageMethodExist; // 健康管理の方法の有無
  String healthManageMethod; // 健康管理の方法

  bool? isSubstanceExist; // 嗜好品
  int alcoholPerDay; // アルコール杯数(1日あたり)
  int cigarettsPerDay; // タバコ本数(1日あたり)
  String otherSubstance; // 嗜好品 - その他
  String otherSubstanceRelatedInfo; // 嗜好品 - その他の関連情報
}

class Nutrition {}

class EliminationAndExchange {}

class ActivityAndRest {}

class PerceptionAndCognition {}

class SelfPerception {}

class Relationship {}

class Sexuality {}

class Coping {}

class LifePrinciples {}

class Safety {}

class Comfort {}

class Growth {}
