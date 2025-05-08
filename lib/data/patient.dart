import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'converters.dart';
import 'nursing_plan.dart';
import 'soap.dart';

part 'patient.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Patient {
  Patient({
    this.id = "",
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

  String id;
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

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$PatientToJson(this);
    json.remove('id');
    return json;
  }
}

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  converters: [TimestampConverter()],
)
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

  factory PersonalInfo.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalInfoToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class RelatedContact {
  RelatedContact({this.name = "", this.relationship = "", this.tel = ""});

  String name;
  String relationship; // 続柄
  String tel;

  factory RelatedContact.fromJson(Map<String, dynamic> json) =>
      _$RelatedContactFromJson(json);

  Map<String, dynamic> toJson() => _$RelatedContactToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
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

  factory HealthPromotion.fromJson(Map<String, dynamic> json) =>
      _$HealthPromotionFromJson(json);

  Map<String, dynamic> toJson() => _$HealthPromotionToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Nutrition {
  Nutrition();
  factory Nutrition.fromJson(Map<String, dynamic> json) =>
      _$NutritionFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class EliminationAndExchange {
  EliminationAndExchange();
  factory EliminationAndExchange.fromJson(Map<String, dynamic> json) =>
      _$EliminationAndExchangeFromJson(json);

  Map<String, dynamic> toJson() => _$EliminationAndExchangeToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ActivityAndRest {
  ActivityAndRest();
  factory ActivityAndRest.fromJson(Map<String, dynamic> json) =>
      _$ActivityAndRestFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityAndRestToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class PerceptionAndCognition {
  PerceptionAndCognition();
  factory PerceptionAndCognition.fromJson(Map<String, dynamic> json) =>
      _$PerceptionAndCognitionFromJson(json);

  Map<String, dynamic> toJson() => _$PerceptionAndCognitionToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SelfPerception {
  SelfPerception();
  factory SelfPerception.fromJson(Map<String, dynamic> json) =>
      _$SelfPerceptionFromJson(json);

  Map<String, dynamic> toJson() => _$SelfPerceptionToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Relationship {
  Relationship();
  factory Relationship.fromJson(Map<String, dynamic> json) =>
      _$RelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$RelationshipToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Sexuality {
  Sexuality();
  factory Sexuality.fromJson(Map<String, dynamic> json) =>
      _$SexualityFromJson(json);

  Map<String, dynamic> toJson() => _$SexualityToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Coping {
  Coping();
  factory Coping.fromJson(Map<String, dynamic> json) => _$CopingFromJson(json);

  Map<String, dynamic> toJson() => _$CopingToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class LifePrinciples {
  LifePrinciples();
  factory LifePrinciples.fromJson(Map<String, dynamic> json) =>
      _$LifePrinciplesFromJson(json);

  Map<String, dynamic> toJson() => _$LifePrinciplesToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Safety {
  Safety();
  factory Safety.fromJson(Map<String, dynamic> json) => _$SafetyFromJson(json);

  Map<String, dynamic> toJson() => _$SafetyToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Comfort {
  Comfort();
  factory Comfort.fromJson(Map<String, dynamic> json) =>
      _$ComfortFromJson(json);

  Map<String, dynamic> toJson() => _$ComfortToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Growth {
  Growth();
  factory Growth.fromJson(Map<String, dynamic> json) => _$GrowthFromJson(json);

  Map<String, dynamic> toJson() => _$GrowthToJson(this);
}
