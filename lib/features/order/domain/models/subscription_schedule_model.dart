class SubscriptionScheduleModel {
  int? id;
  int? subscriptionId;
  String? type;
  int? day;
  String? time;
  String? createdAt;
  String? updatedAt;

  SubscriptionScheduleModel(
      {this.id,
        this.subscriptionId,
        this.type,
        this.day,
        this.time,
        this.createdAt,
        this.updatedAt});

  SubscriptionScheduleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subscriptionId = json['subscription_id'];
    type = json['type'];
    day = json['day'];
    time = json['time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subscription_id'] = subscriptionId;
    data['type'] = type;
    data['day'] = day;
    data['time'] = time;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
