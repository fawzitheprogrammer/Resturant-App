class PaginatedDeliveryLogModel {
  int? totalSize;
  String? limit;
  int? offset;
  List<DeliveryLogModel>? data;

  PaginatedDeliveryLogModel({this.totalSize, this.limit, this.offset, this.data});

  PaginatedDeliveryLogModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = (json['offset'] != null && json['offset'].toString().trim().isNotEmpty) ? int.parse(json['offset'].toString()) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(DeliveryLogModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class DeliveryLogModel {
  int? id;
  int? orderId;
  int? deliveryManId;
  int? subscriptionId;
  String? orderStatus;
  String? accepted;
  String? scheduleAt;
  String? confirmed;
  String? processing;
  String? handover;
  String? pickedUp;
  String? delivered;
  String? canceled;
  String? failed;
  String? createdAt;
  String? updatedAt;

  DeliveryLogModel(
      {this.id,
        this.orderId,
        this.deliveryManId,
        this.subscriptionId,
        this.orderStatus,
        this.accepted,
        this.scheduleAt,
        this.confirmed,
        this.processing,
        this.handover,
        this.pickedUp,
        this.delivered,
        this.canceled,
        this.failed,
        this.createdAt,
        this.updatedAt});

  DeliveryLogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    deliveryManId = json['delivery_man_id'];
    subscriptionId = json['subscription_id'];
    orderStatus = json['order_status'];
    accepted = json['accepted'];
    scheduleAt = json['schedule_at'];
    confirmed = json['confirmed'];
    processing = json['processing'];
    handover = json['handover'];
    pickedUp = json['picked_up'];
    delivered = json['delivered'];
    canceled = json['canceled'];
    failed = json['failed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['delivery_man_id'] = deliveryManId;
    data['subscription_id'] = subscriptionId;
    data['order_status'] = orderStatus;
    data['accepted'] = accepted;
    data['schedule_at'] = scheduleAt;
    data['confirmed'] = confirmed;
    data['processing'] = processing;
    data['handover'] = handover;
    data['picked_up'] = pickedUp;
    data['delivered'] = delivered;
    data['canceled'] = canceled;
    data['failed'] = failed;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
