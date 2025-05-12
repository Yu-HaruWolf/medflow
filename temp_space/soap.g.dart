// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Soap _$SoapFromJson(Map<String, dynamic> json) => Soap(
  issueDateTime: _$JsonConverterFromJson<String, DateTime>(
    json['issueDateTime'],
    const TimestampConverter().fromJson,
  ),
  subject: json['subject'] as String? ?? "",
  object: json['object'] as String? ?? "",
  assessment: json['assessment'] as String? ?? "",
  plan: json['plan'] as String? ?? "",
);

Map<String, dynamic> _$SoapToJson(Soap instance) => <String, dynamic>{
  'issueDateTime': const TimestampConverter().toJson(instance.issueDateTime),
  'subject': instance.subject,
  'object': instance.object,
  'assessment': instance.assessment,
  'plan': instance.plan,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);
