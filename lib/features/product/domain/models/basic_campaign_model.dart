import 'package:stackfood_multivendor/common/models/restaurant_model.dart';

class BasicCampaignModel {
  int? id;
  String? title;
  String? image;
  String? description;
  String? availableDateStarts;
  String? availableDateEnds;
  String? startTime;
  String? endTime;
  List<Restaurant>? restaurants;

  BasicCampaignModel(
      {this.id,
        this.title,
        this.image,
        this.description,
        this.availableDateStarts,
        this.availableDateEnds,
        this.startTime,
        this.endTime,
        this.restaurants});

  BasicCampaignModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    availableDateStarts = json['available_date_starts'];
    availableDateEnds = json['available_date_ends'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    if (json['restaurants'] != null) {
      restaurants = [];
      json['restaurants'].forEach((v) {
        restaurants!.add(Restaurant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['description'] = description;
    data['available_date_starts'] = availableDateStarts;
    data['available_date_ends'] = availableDateEnds;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    if (restaurants != null) {
      data['restaurants'] = restaurants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
