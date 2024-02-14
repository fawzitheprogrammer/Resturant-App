class DateMonthBodyModel{
  int? date;
  int? month;
  DateMonthBodyModel({required this.date, required this.month});

  DateMonthBodyModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    month = json['month'];
  }
}