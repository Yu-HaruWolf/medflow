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
}
