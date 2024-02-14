import 'dart:convert';

class RestaurantBodyModel {
  String? translation;
  String? deliveryTimeType;
  String? vat;
  String? minDeliveryTime;
  String? maxDeliveryTime;
  String? lat;
  String? lng;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? password;
  String? zoneId;
  List<String>? cuisineId;

  RestaurantBodyModel(
      {this.translation,
        this.deliveryTimeType,
        this.vat,
        this.minDeliveryTime,
        this.maxDeliveryTime,
        this.lat,
        this.lng,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.password,
        this.zoneId,
        this.cuisineId,
      });

  RestaurantBodyModel.fromJson(Map<String, dynamic> json) {
    translation = json['translations'];
    deliveryTimeType = json['delivery_time_type'];
    vat = json['vat'];
    minDeliveryTime = json['min_delivery_time'];
    maxDeliveryTime = json['max_delivery_time'];
    lat = json['lat'];
    lng = json['lng'];
    fName = json['fName'];
    lName = json['lName'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    zoneId = json['zone_id'];
    cuisineId = json['cuisine_ids'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['translations'] = translation!;
    data['delivery_time_type'] = deliveryTimeType!;
    data['vat'] = vat!;
    data['min_delivery_time'] = minDeliveryTime!;
    data['max_delivery_time'] = maxDeliveryTime!;
    data['lat'] = lat!;
    data['lng'] = lng!;
    data['fName'] = fName!;
    data['lName'] = lName!;
    data['phone'] = phone!;
    data['email'] = email!;
    data['password'] = password!;
    data['zone_id'] = zoneId!;
    data['cuisine_ids'] = jsonEncode(cuisineId);

    return data;
  }
}
