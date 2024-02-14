class PricingViewModel{
  double? _subTotal;
  int? _subscriptionQty;
  double? _discount;
  bool? _taxIncluded;
  double? _tax;
  double? _deliveryCharge;
  double? _total;
  double? _taxPercent;

  PricingViewModel({
    required double subTotal,
    required int subscriptionQty,
    required double discount,
    required bool taxIncluded,
    required double tax,
    required double deliveryCharge,
    required double total,
    required double taxPercent,
  }) {
    _subTotal = subTotal;
    _subscriptionQty = subscriptionQty;
    _discount = discount;
    _taxIncluded = taxIncluded;
    _tax = tax;
    _deliveryCharge = deliveryCharge;
    _total = total;
    _taxPercent = taxPercent;
  }

  double? get subTotal => _subTotal;
  int? get subscriptionQty => _subscriptionQty;
  double? get discount => _discount;
  bool? get taxIncluded => _taxIncluded;
  double? get tax => _tax;
  double? get deliveryCharge => _deliveryCharge;
  double? get total => _total;
  double? get taxPercent => _taxPercent;

  //fromJson
  PricingViewModel.fromJson(Map<String, dynamic> json) {
    _subTotal = json['subTotal'];
    _subscriptionQty = json['subscriptionQty'];
    _discount = json['discount'];
    _taxIncluded = json['taxIncluded'];
    _tax = json['tax'];
    _deliveryCharge = json['deliveryCharge'];
    _total = json['total'];
    _taxPercent = json['taxPercent'];
  }

  //toJson
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subTotal'] = _subTotal;
    data['subscriptionQty'] = _subscriptionQty;
    data['discount'] = _discount;
    data['taxIncluded'] = _taxIncluded;
    data['tax'] = _tax;
    data['deliveryCharge'] = _deliveryCharge;
    data['total'] = _total;
    data['taxPercent'] = _taxPercent;
    return data;
  }
}