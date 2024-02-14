import 'package:stackfood_multivendor/common/models/product_model.dart';

class CartSuggestItemModel {
  List<Product>? items;

  CartSuggestItemModel({this.items});

  CartSuggestItemModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Product>[];
      json['items'].forEach((v) {
        items!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
