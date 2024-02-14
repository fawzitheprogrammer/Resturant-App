import 'package:stackfood_multivendor/common/models/product_model.dart';

class RecommendedProductModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<Product>? products;

  RecommendedProductModel(
      {this.totalSize, this.limit, this.offset, this.products});

  RecommendedProductModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['products'] != null) {
      products = <Product>[];
      json['products'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
