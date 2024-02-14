import 'package:stackfood_multivendor/common/models/product_model.dart';

class CartModel {
  int? _id;
  double? _price;
  double? _discountedPrice;
  List<List<bool?>>? _variations;
  double? _discountAmount;
  int? _quantity;
  List<AddOn>? _addOnIds;
  List<AddOns>? _addOns;
  bool? _isCampaign;
  Product? _product;
  int? _quantityLimit;

  CartModel(
      int? id,
      double price,
      double? discountedPrice,
      double discountAmount,
      int? quantity,
      List<AddOn> addOnIds,
      List<AddOns> addOns,
      bool isCampaign,
      Product? product,
      List<List<bool?>> variations,
      int? quantityLimit) {
    _id = id;
    _price = price;
    _discountedPrice = discountedPrice;
    _discountAmount = discountAmount;
    _quantity = quantity;
    _addOnIds = addOnIds;
    _addOns = addOns;
    _isCampaign = isCampaign;
    _product = product;
    _variations = variations;
    _quantityLimit = quantityLimit;
  }

  int? get id => _id;
  double? get price => _price;
  double? get discountedPrice => _discountedPrice;
  double? get discountAmount => _discountAmount;
  // ignore: unnecessary_getters_setters
  int? get quantity => _quantity;
  // ignore: unnecessary_getters_setters
  set quantity(int? qty) => _quantity = qty;
  List<AddOn>? get addOnIds => _addOnIds;
  List<AddOns>? get addOns => _addOns;
  bool? get isCampaign => _isCampaign;
  Product? get product => _product;
  List<List<bool?>>? get variations => _variations;
  int? get quantityLimit => _quantityLimit;

  CartModel.fromJson(Map<String, dynamic> json) {
    _id = json['cart_id'];
    _price = json['price'].toDouble();
    _discountedPrice = json['discounted_price']?.toDouble();
    _discountAmount = json['discount_amount']?.toDouble();
    _quantity = json['quantity'];
    if (json['add_on_ids'] != null) {
      _addOnIds = [];
      json['add_on_ids'].forEach((v) {
        _addOnIds!.add(AddOn.fromJson(v));
      });
    }
    if (json['add_ons'] != null) {
      _addOns = [];
      json['add_ons'].forEach((v) {
        _addOns!.add(AddOns.fromJson(v));
      });
    }
    _isCampaign = json['is_campaign'];
    if (json['product'] != null) {
      _product = Product.fromJson(json['product']);
    }
    if (json['variations'] != null) {
      _variations = [];
      for(int index=0; index<json['variations'].length; index++) {
        _variations!.add([]);
        for(int i=0; i<json['variations'][index].length; i++) {
          _variations![index].add(json['variations'][index][i]);
        }
      }
    }
    if(json['quantity_limit'] != null) {
      _quantityLimit = int.parse(json['quantity_limit']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = _price;
    data['discounted_price'] = _discountedPrice;
    data['discount_amount'] = _discountAmount;
    data['quantity'] = _quantity;
    if (_addOnIds != null) {
      data['add_on_ids'] = _addOnIds!.map((v) => v.toJson()).toList();
    }
    if (_addOns != null) {
      data['add_ons'] = _addOns!.map((v) => v.toJson()).toList();
    }
    data['is_campaign'] = _isCampaign;
    data['product'] = _product!.toJson();
    data['variations'] = _variations;
    data['quantity_limit'] = _quantityLimit?.toString();
    return data;
  }
}

class AddOn {
  int? _id;
  int? _quantity;

  AddOn({int? id, int? quantity}) {
    _id = id;
    _quantity = quantity;
  }

  int? get id => _id;
  int? get quantity => _quantity;

  AddOn.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['quantity'] = _quantity;
    return data;
  }
}
