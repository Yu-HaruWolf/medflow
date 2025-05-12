import 'package:json_annotation/json_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime, String> {
  const TimestampConverter();

  @override
  DateTime fromJson(String timestamp) => DateTime.now(); // 今回は戻すことを想定しない

  @override
  String toJson(DateTime date) => date.toString();
}
