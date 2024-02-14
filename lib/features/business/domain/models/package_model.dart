
class PackageModel {
  List<Packages>? packages;

  PackageModel({this.packages});

  PackageModel.fromJson(Map<String, dynamic> json) {
    if (json['packages'] != null) {
      packages = <Packages>[];
      json['packages'].forEach((v) { packages!.add(Packages.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (packages != null) {
      data['packages'] = packages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Packages {
  int? id;
  String? packageName;
  double? price;
  int? validity;
  String? maxOrder;
  String? maxProduct;
  int? pos;
  int? mobileApp;
  int? chat;
  int? review;
  int? selfDelivery;
  int? status;
  int? def;
  String? createdAt;
  String? updatedAt;
  String? color;

  Packages({this.id, this.packageName, this.price, this.validity, this.maxOrder, this.maxProduct, this.pos, this.mobileApp, this.chat, this.review, this.selfDelivery, this.status, this.def, this.createdAt, this.updatedAt, this.color});

Packages.fromJson(Map<String, dynamic> json) {
id = json['id'];
packageName = json['package_name'];
price = json['price'].toDouble();
validity = json['validity'];
maxOrder = json['max_order'];
maxProduct = json['max_product'];
pos = json['pos'];
mobileApp = json['mobile_app'];
chat = json['chat'];
review = json['review'];
selfDelivery = json['self_delivery'];
status = json['status'];
def = json['default'];
createdAt = json['created_at'];
updatedAt = json['updated_at'];
color = json['colour'];
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = id;
  data['package_name'] = packageName;
  data['price'] = price;
  data['validity'] = validity;
  data['max_order'] = maxOrder;
  data['max_product'] = maxProduct;
  data['pos'] = pos;
  data['mobile_app'] = mobileApp;
  data['chat'] = chat;
  data['review'] = review;
  data['self_delivery'] = selfDelivery;
  data['status'] = status;
  data['default'] = def;
  data['created_at'] = createdAt;
  data['updated_at'] = updatedAt;
  data['colour'] = color;
  return data;
}
}
