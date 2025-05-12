import 'package:json_annotation/json_annotation.dart';

import 'converters.dart';

part 'nursing_plan.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  converters: [TimestampConverter()],
)
class NursingPlan {
  NursingPlan({
    DateTime? issueDateTime,
    this.nanda_i = "",
    this.goal = "",
    this.op = "",
    this.tp = "",
    this.ep = "",
  }) : issueDateTime = issueDateTime ?? DateTime.now();
  DateTime issueDateTime;
  String nanda_i;
  String goal;
  String op; // 観察項目
  String tp; // 援助
  String ep; // 指導

  factory NursingPlan.fromJson(Map<String, dynamic> json) =>
      _$NursingPlanFromJson(json);

  Map<String, dynamic> toJson() => _$NursingPlanToJson(this);
}
