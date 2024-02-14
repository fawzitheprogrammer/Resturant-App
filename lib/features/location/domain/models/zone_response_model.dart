class ZoneResponseModel {
  final bool _isSuccess;
  final List<int> _zoneIds;
  final String? _message;
  final List<ZoneData> _zoneData;
  ZoneResponseModel(this._isSuccess, this._message, this._zoneIds, this._zoneData);

  String? get message => _message;
  List<int> get zoneIds => _zoneIds;
  bool get isSuccess => _isSuccess;
  List<ZoneData> get zoneData => _zoneData;
}

class ZoneData {
  int? id;
  int? status;
  double? minimumShippingCharge;
  double? increasedDeliveryFee;
  int? increasedDeliveryFeeStatus;
  String? increaseDeliveryFeeMessage;
  double? perKmShippingCharge;
  double? maxCodOrderAmount;
  double? maximumShippingCharge;

  ZoneData({
    this.id,
    this.status,
    this.minimumShippingCharge,
    this.increasedDeliveryFee,
    this.increasedDeliveryFeeStatus,
    this.increaseDeliveryFeeMessage,
    this.perKmShippingCharge,
    this.maxCodOrderAmount,
    this.maximumShippingCharge,
  });

  ZoneData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    minimumShippingCharge = json['minimum_shipping_charge']?.toDouble();
    increasedDeliveryFee = json['increased_delivery_fee']?.toDouble();
    increasedDeliveryFeeStatus = json['increased_delivery_fee_status'];
    increaseDeliveryFeeMessage = json['increase_delivery_charge_message'];
    perKmShippingCharge = json['per_km_shipping_charge']?.toDouble();
    maxCodOrderAmount = json['max_cod_order_amount']?.toDouble();
    maximumShippingCharge = json['maximum_shipping_charge']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['minimum_shipping_charge'] = minimumShippingCharge;
    data['increased_delivery_fee'] = increasedDeliveryFee;
    data['increased_delivery_fee_status'] = increasedDeliveryFeeStatus;
    data['increase_delivery_charge_message'] = increaseDeliveryFeeMessage;
    data['per_km_shipping_charge'] = perKmShippingCharge;
    data['max_cod_order_amount'] = maxCodOrderAmount;
    data['maximum_shipping_charge'] = maximumShippingCharge;
    return data;
  }
}

