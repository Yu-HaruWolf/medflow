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
  nutrition:
      json['nutrition'] == null
          ? null
          : Nutrition.fromJson(json['nutrition'] as Map<String, dynamic>),
  eliminationAndExchange:
      json['eliminationAndExchange'] == null
          ? null
          : EliminationAndExchange.fromJson(
            json['eliminationAndExchange'] as Map<String, dynamic>,
          ),
  activityAndRest:
      json['activityAndRest'] == null
          ? null
          : ActivityAndRest.fromJson(
            json['activityAndRest'] as Map<String, dynamic>,
          ),
  perceptionAndCognition:
      json['perceptionAndCognition'] == null
          ? null
          : PerceptionAndCognition.fromJson(
            json['perceptionAndCognition'] as Map<String, dynamic>,
          ),
  selfPerception:
      json['selfPerception'] == null
          ? null
          : SelfPerception.fromJson(
            json['selfPerception'] as Map<String, dynamic>,
          ),
  relationship:
      json['relationship'] == null
          ? null
          : Relationship.fromJson(json['relationship'] as Map<String, dynamic>),
  sexuality:
      json['sexuality'] == null
          ? null
          : Sexuality.fromJson(json['sexuality'] as Map<String, dynamic>),
  coping:
      json['coping'] == null
          ? null
          : Coping.fromJson(json['coping'] as Map<String, dynamic>),
  lifePrinciples:
      json['lifePrinciples'] == null
          ? null
          : LifePrinciples.fromJson(
            json['lifePrinciples'] as Map<String, dynamic>,
          ),
  safety:
      json['safety'] == null
          ? null
          : Safety.fromJson(json['safety'] as Map<String, dynamic>),
  comfort:
      json['comfort'] == null
          ? null
          : Comfort.fromJson(json['comfort'] as Map<String, dynamic>),
  growth:
      json['growth'] == null
          ? null
          : Growth.fromJson(json['growth'] as Map<String, dynamic>),
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
  'nutrition': instance.nutrition.toJson(),
  'eliminationAndExchange': instance.eliminationAndExchange.toJson(),
  'activityAndRest': instance.activityAndRest.toJson(),
  'perceptionAndCognition': instance.perceptionAndCognition.toJson(),
  'selfPerception': instance.selfPerception.toJson(),
  'relationship': instance.relationship.toJson(),
  'sexuality': instance.sexuality.toJson(),
  'coping': instance.coping.toJson(),
  'lifePrinciples': instance.lifePrinciples.toJson(),
  'safety': instance.safety.toJson(),
  'comfort': instance.comfort.toJson(),
  'growth': instance.growth.toJson(),
  'historyOfSoap': instance.historyOfSoap.map((e) => e.toJson()).toList(),
  'nursingPlan': instance.nursingPlan.toJson(),
};

PersonalInfo _$PersonalInfoFromJson(Map<String, dynamic> json) => PersonalInfo(
  furigana: json['furigana'] as String? ?? "",
  name: json['name'] as String? ?? "",
  birthday: _$JsonConverterFromJson<Timestamp, DateTime>(
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
      if (_$JsonConverterToJson<Timestamp, DateTime>(
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
      alcoholPerDay: (json['alcoholPerDay'] as num?)?.toInt() ?? 0,
      cigarettsPerDay: (json['cigarettsPerDay'] as num?)?.toInt() ?? 0,
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
  'alcoholPerDay': instance.alcoholPerDay,
  'cigarettsPerDay': instance.cigarettsPerDay,
  'otherSubstance': instance.otherSubstance,
  'otherSubstanceRelatedInfo': instance.otherSubstanceRelatedInfo,
};

Nutrition _$NutritionFromJson(Map<String, dynamic> json) => Nutrition();

Map<String, dynamic> _$NutritionToJson(Nutrition instance) =>
    <String, dynamic>{};

EliminationAndExchange _$EliminationAndExchangeFromJson(
  Map<String, dynamic> json,
) => EliminationAndExchange();

Map<String, dynamic> _$EliminationAndExchangeToJson(
  EliminationAndExchange instance,
) => <String, dynamic>{};

ActivityAndRest _$ActivityAndRestFromJson(Map<String, dynamic> json) =>
    ActivityAndRest();

Map<String, dynamic> _$ActivityAndRestToJson(ActivityAndRest instance) =>
    <String, dynamic>{};

PerceptionAndCognition _$PerceptionAndCognitionFromJson(
  Map<String, dynamic> json,
) => PerceptionAndCognition();

Map<String, dynamic> _$PerceptionAndCognitionToJson(
  PerceptionAndCognition instance,
) => <String, dynamic>{};

SelfPerception _$SelfPerceptionFromJson(Map<String, dynamic> json) =>
    SelfPerception();

Map<String, dynamic> _$SelfPerceptionToJson(SelfPerception instance) =>
    <String, dynamic>{};

Relationship _$RelationshipFromJson(Map<String, dynamic> json) =>
    Relationship();

Map<String, dynamic> _$RelationshipToJson(Relationship instance) =>
    <String, dynamic>{};

Sexuality _$SexualityFromJson(Map<String, dynamic> json) => Sexuality();

Map<String, dynamic> _$SexualityToJson(Sexuality instance) =>
    <String, dynamic>{};

Coping _$CopingFromJson(Map<String, dynamic> json) => Coping();

Map<String, dynamic> _$CopingToJson(Coping instance) => <String, dynamic>{};

LifePrinciples _$LifePrinciplesFromJson(Map<String, dynamic> json) =>
    LifePrinciples();

Map<String, dynamic> _$LifePrinciplesToJson(LifePrinciples instance) =>
    <String, dynamic>{};

Safety _$SafetyFromJson(Map<String, dynamic> json) => Safety();

Map<String, dynamic> _$SafetyToJson(Safety instance) => <String, dynamic>{};

Comfort _$ComfortFromJson(Map<String, dynamic> json) => Comfort();

Map<String, dynamic> _$ComfortToJson(Comfort instance) => <String, dynamic>{};

Growth _$GrowthFromJson(Map<String, dynamic> json) => Growth();

Map<String, dynamic> _$GrowthToJson(Growth instance) => <String, dynamic>{};
