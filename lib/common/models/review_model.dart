class ReviewModel {
  int? id;
  String? comment;
  int? rating;
  String? foodName;
  String? foodImage;
  String? customerName;
  String? createdAt;
  String? updatedAt;

  ReviewModel(
      {this.id,
        this.comment,
        this.rating,
        this.foodName,
        this.foodImage,
        this.customerName,
        this.createdAt,
        this.updatedAt});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    rating = json['rating'];
    foodName = json['food_name'];
    foodImage = json['food_image'];
    customerName = json['customer_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['rating'] = rating;
    data['food_name'] = foodName;
    data['food_image'] = foodImage;
    data['customer_name'] = customerName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
