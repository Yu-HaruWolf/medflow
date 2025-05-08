import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'converters.dart';

part 'soap.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  converters: [TimestampConverter()],
)
class Soap {
  Soap({
    DateTime? issueDateTime,
    this.subject = "",
    this.object = "",
    this.assessment = "",
    this.plan = "",
  }) : issueDateTime = issueDateTime ?? DateTime.now();
  DateTime issueDateTime;
  String subject;
  String object;
  String assessment;
  String plan;

  factory Soap.fromJson(Map<String, dynamic> json) => _$SoapFromJson(json);

  Map<String, dynamic> toJson() => _$SoapToJson(this);
}
