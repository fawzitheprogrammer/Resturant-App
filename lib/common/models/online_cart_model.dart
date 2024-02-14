import 'package:stackfood_multivendor/common/models/product_model.dart';

class OnlineCartModel {
  int? id;
  int? userId;
  int? itemId;
  bool? isGuest;
  List<int>? addOnIds;
  List<int>? addOnQtys;
  String? itemType;
  double? price;
  int? quantity;
  List<Variation>? variation;
  String? createdAt;
  String? updatedAt;
  Product? product;

  OnlineCartModel(
      {this.id,
        this.userId,
        this.itemId,
        this.isGuest,
        this.addOnIds,
        this.addOnQtys,
        this.itemType,
        this.price,
        this.quantity,
        this.variation,
        this.createdAt,
        this.updatedAt,
        this.product});

  OnlineCartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    itemId = json['item_id'];
    isGuest = json['is_guest'];
    addOnIds = json['add_on_ids'].cast<int>();
    addOnQtys = json['add_on_qtys'].cast<int>();
    itemType = json['item_type'];
    price = json['price']?.toDouble();
    quantity = json['quantity'];
    if (json['variations'] != null) {
      variation = [];
      json['variations'].forEach((v) {
        variation!.add(Variation.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product = json['item'] != null ? Product.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['item_id'] = itemId;
    data['is_guest'] = isGuest;
    data['add_on_ids'] = addOnIds;
    data['add_on_qtys'] = addOnQtys;
    data['item_type'] = itemType;
    data['price'] = price;
    data['quantity'] = quantity;
    if (variation != null) {
      data['variations'] = variation!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (product != null) {
      data['item'] = product!.toJson();
    }
    return data;
  }
}

class Variation {
  String? name;
  Value? values;

  Variation({this.name, this.values});

  Variation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    values = json['values'] != null ? Value.fromJson(json['values']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (values != null) {
      data['values'] = values!.toJson();
    }
    return data;
  }
}

class Value {
  List<String>? label;

  Value({this.label});

  Value.fromJson(Map<String, dynamic> json) {
    label = json['label'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    return data;
  }
}
