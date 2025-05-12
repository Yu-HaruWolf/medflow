// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nursing_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NursingPlan _$NursingPlanFromJson(Map<String, dynamic> json) => NursingPlan(
  issueDateTime: _$JsonConverterFromJson<String, DateTime>(
    json['issueDateTime'],
    const TimestampConverter().fromJson,
  ),
  nanda_i: json['nanda_i'] as String? ?? "",
  goal: json['goal'] as String? ?? "",
  op: json['op'] as String? ?? "",
  tp: json['tp'] as String? ?? "",
  ep: json['ep'] as String? ?? "",
);

Map<String, dynamic> _$NursingPlanToJson(
  NursingPlan instance,
) => <String, dynamic>{
  'issueDateTime': const TimestampConverter().toJson(instance.issueDateTime),
  'nanda_i': instance.nanda_i,
  'goal': instance.goal,
  'op': instance.op,
  'tp': instance.tp,
  'ep': instance.ep,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);
