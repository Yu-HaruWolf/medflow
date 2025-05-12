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
    SelfPerception? selfPerception,
    NursingPlan? nursingPlan,
    this.historyOfSoap = const [],
  }) : personalInfo = personalInfo ?? PersonalInfo(),
       healthPromotion = healthPromotion ?? HealthPromotion(),
       selfPerception = selfPerception ?? SelfPerception(),
       nursingPlan = nursingPlan ?? NursingPlan();

  String id;
  PersonalInfo personalInfo;
  List<RelatedContact> relatedContacts;
  HealthPromotion healthPromotion;
  SelfPerception selfPerception;

  List<Soap> historyOfSoap;
  NursingPlan nursingPlan;

  void addHistoryOfSoap(Soap soap) {
    historyOfSoap.add(soap);
  }

  factory Patient.fromJson(Map<String, dynamic> json, String id) {
    Patient patient = _$PatientFromJson(json);
    patient.id = id;
    return patient;
  }

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
    this.alcoholPerDay,
    this.cigarettsPerDay,
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
  int? alcoholPerDay; // アルコール杯数(1日あたり)
  int? cigarettsPerDay; // タバコ本数(1日あたり)
  String otherSubstance; // 嗜好品 - その他
  String otherSubstanceRelatedInfo; // 嗜好品 - その他の関連情報

  factory HealthPromotion.fromJson(Map<String, dynamic> json) =>
      _$HealthPromotionFromJson(json);

  Map<String, dynamic> toJson() => _$HealthPromotionToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SelfPerception {
  SelfPerception({
    this.selfAwareness = "",
    this.worries = "",
    this.howCanHelp = "",
    this.pains = "",
    this.others = "",
  });
  String selfAwareness; // 自分のことをどう思っていますか
  String worries; // いま、悩みや不安、恐怖、抑うつ、絶望を感じていますか
  String howCanHelp; // 悩みや不安に対し、手助けできることはありますか
  String pains; // 身体の外観の痛みはありますか
  String others; // その他の関連事項

  factory SelfPerception.fromJson(Map<String, dynamic> json) =>
      _$SelfPerceptionFromJson(json);

  Map<String, dynamic> toJson() => _$SelfPerceptionToJson(this);
}
