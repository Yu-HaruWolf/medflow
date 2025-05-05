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
}
