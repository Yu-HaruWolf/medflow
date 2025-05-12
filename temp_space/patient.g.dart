// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
  id: json['id'] as String? ?? "",
  relatedContacts:
      (json['relatedContacts'] as List<dynamic>?)
          ?.map((e) => RelatedContact.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  personalInfo:
      json['personalInfo'] == null
          ? null
          : PersonalInfo.fromJson(json['personalInfo'] as Map<String, dynamic>),
  healthPromotion:
      json['healthPromotion'] == null
          ? null
          : HealthPromotion.fromJson(
            json['healthPromotion'] as Map<String, dynamic>,
          ),
  selfPerception:
      json['selfPerception'] == null
          ? null
          : SelfPerception.fromJson(
            json['selfPerception'] as Map<String, dynamic>,
          ),
  nursingPlan:
      json['nursingPlan'] == null
          ? null
          : NursingPlan.fromJson(json['nursingPlan'] as Map<String, dynamic>),
  historyOfSoap:
      (json['historyOfSoap'] as List<dynamic>?)
          ?.map((e) => Soap.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
  'id': instance.id,
  'personalInfo': instance.personalInfo.toJson(),
  'relatedContacts': instance.relatedContacts.map((e) => e.toJson()).toList(),
  'healthPromotion': instance.healthPromotion.toJson(),
  'selfPerception': instance.selfPerception.toJson(),
  'historyOfSoap': instance.historyOfSoap.map((e) => e.toJson()).toList(),
  'nursingPlan': instance.nursingPlan.toJson(),
};

PersonalInfo _$PersonalInfoFromJson(Map<String, dynamic> json) => PersonalInfo(
  furigana: json['furigana'] as String? ?? "",
  name: json['name'] as String? ?? "",
  birthday: _$JsonConverterFromJson<String, DateTime>(
    json['birthday'],
    const TimestampConverter().fromJson,
  ),
  address: json['address'] as String? ?? "",
  tel: json['tel'] as String? ?? "",
);

Map<String, dynamic> _$PersonalInfoToJson(PersonalInfo instance) =>
    <String, dynamic>{
      'furigana': instance.furigana,
      'name': instance.name,
      if (_$JsonConverterToJson<String, DateTime>(
            instance.birthday,
            const TimestampConverter().toJson,
          )
          case final value?)
        'birthday': value,
      'address': instance.address,
      'tel': instance.tel,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

RelatedContact _$RelatedContactFromJson(Map<String, dynamic> json) =>
    RelatedContact(
      name: json['name'] as String? ?? "",
      relationship: json['relationship'] as String? ?? "",
      tel: json['tel'] as String? ?? "",
    );

Map<String, dynamic> _$RelatedContactToJson(RelatedContact instance) =>
    <String, dynamic>{
      'name': instance.name,
      'relationship': instance.relationship,
      'tel': instance.tel,
    };

HealthPromotion _$HealthPromotionFromJson(Map<String, dynamic> json) =>
    HealthPromotion(
      preHospitalCourse: json['preHospitalCourse'] as String? ?? "",
      chiefComplaint: json['chiefComplaint'] as String? ?? "",
      purpose: json['purpose'] as String? ?? "",
      opinions:
          (json['opinions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {"doctor": "", "principal": "", "family": ""},
      pastMedicalHistory: json['pastMedicalHistory'] as String? ?? "",
      isMedicinesExist: json['isMedicinesExist'] as bool?,
      medicines: json['medicines'] as String? ?? "",
      isHealthManageMethodExist: json['isHealthManageMethodExist'] as bool?,
      healthManageMethod: json['healthManageMethod'] as String? ?? "",
      isSubstanceExist: json['isSubstanceExist'] as bool?,
      alcoholPerDay: (json['alcoholPerDay'] as num?)?.toInt(),
      cigarettsPerDay: (json['cigarettsPerDay'] as num?)?.toInt(),
      otherSubstance: json['otherSubstance'] as String? ?? "",
      otherSubstanceRelatedInfo:
          json['otherSubstanceRelatedInfo'] as String? ?? "",
    );

Map<String, dynamic> _$HealthPromotionToJson(
  HealthPromotion instance,
) => <String, dynamic>{
  'preHospitalCourse': instance.preHospitalCourse,
  'chiefComplaint': instance.chiefComplaint,
  'purpose': instance.purpose,
  'opinions': instance.opinions,
  'pastMedicalHistory': instance.pastMedicalHistory,
  if (instance.isMedicinesExist case final value?) 'isMedicinesExist': value,
  'medicines': instance.medicines,
  if (instance.isHealthManageMethodExist case final value?)
    'isHealthManageMethodExist': value,
  'healthManageMethod': instance.healthManageMethod,
  if (instance.isSubstanceExist case final value?) 'isSubstanceExist': value,
  if (instance.alcoholPerDay case final value?) 'alcoholPerDay': value,
  if (instance.cigarettsPerDay case final value?) 'cigarettsPerDay': value,
  'otherSubstance': instance.otherSubstance,
  'otherSubstanceRelatedInfo': instance.otherSubstanceRelatedInfo,
};

SelfPerception _$SelfPerceptionFromJson(Map<String, dynamic> json) =>
    SelfPerception(
      selfAwareness: json['selfAwareness'] as String? ?? "",
      worries: json['worries'] as String? ?? "",
      howCanHelp: json['howCanHelp'] as String? ?? "",
      pains: json['pains'] as String? ?? "",
      others: json['others'] as String? ?? "",
    );

Map<String, dynamic> _$SelfPerceptionToJson(SelfPerception instance) =>
    <String, dynamic>{
      'selfAwareness': instance.selfAwareness,
      'worries': instance.worries,
      'howCanHelp': instance.howCanHelp,
      'pains': instance.pains,
      'others': instance.others,
    };
