import 'dart:convert';

import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/order/domain/models/delivery_log_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_cancellation_body.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/pause_log_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/refund_model.dart';
import 'package:stackfood_multivendor/features/order/domain/repositories/order_repository_interface.dart';
import 'package:stackfood_multivendor/helper/auth_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:get/get_connect.dart';
import 'package:image_picker/image_picker.dart';

class OrderRepository implements OrderRepositoryInterface {
  final ApiClient apiClient;
  OrderRepository({required this.apiClient});

  @override
  Future<OrderModel?> trackOrder(String? orderID, String? guestId, {String? contactNumber}) async {
    OrderModel? trackModel;
    Response response = await apiClient.getData(
      '${AppConstants.trackUri}$orderID${guestId != null ? '&guest_id=$guestId' : ''}'
          '${contactNumber != null ? '&contact_number=$contactNumber' : ''}',
    );
    if (response.statusCode == 200) {
      trackModel = OrderModel.fromJson(response.body);
    }
    return trackModel;
  }

  @override
  Future<List<CancellationData>?> getCancelReasons() async {
    List<CancellationData>? orderCancelReasons;
    Response response = await apiClient.getData('${AppConstants.orderCancellationUri}?offset=1&limit=30&type=customer');
    if (response.statusCode == 200) {
      OrderCancellationBody orderCancellationBody = OrderCancellationBody.fromJson(response.body);
      orderCancelReasons = [];
      for (var element in orderCancellationBody.reasons!) {
        orderCancelReasons.add(element);
      }
    }
    return orderCancelReasons;
  }

  @override
  Future<ResponseModel> switchToCOD(String? orderID) async {
    Map<String, String> data = {'_method': 'put', 'order_id': orderID!};
    if(AuthHelper.isGuestLoggedIn()) {
      data.addAll({'guest_id': AuthHelper.getGuestId()});
    }
    Response response = await apiClient.postData(AppConstants.codSwitchUri, data);
    if(response.statusCode == 200) {
      return ResponseModel(true, response.body['message']);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<List<Product>?> getFoodsFromFoodIds(List<int?> ids) async {
    List<Product>? foods;
    Response response = await apiClient.postData(AppConstants.productListWithIdsUri, {'food_id': jsonEncode(ids)});
    if (response.statusCode == 200) {
      foods = [];
      response.body.forEach((food) => foods!.add(Product.fromJson(food)));
    }
    return foods;
  }

  @override
  Future<List<String?>?> getRefundReasons() async {
    List<String?>? refundReasons;
    Response response = await apiClient.getData(AppConstants.refundReasonsUri);
    if (response.statusCode == 200) {
      RefundModel refundModel = RefundModel.fromJson(response.body);
      refundReasons = [];
      refundReasons.insert(0, 'select_an_option');
      for (var element in refundModel.refundReasons!) {
        refundReasons.add(element.reason);
      }
    }
    return refundReasons;
  }

  @override
  Future<ResponseModel> submitRefundRequest(Map<String, String> body, XFile? data, String? guestId) async {
    Response response = await apiClient.postMultipartData('${AppConstants.refundRequestUri}${guestId != null ? '?guest_id=$guestId' : ''}', body,  [MultipartBody('image[]', data)], []);
    if(response.statusCode == 200) {
      return ResponseModel(true, response.body['message']);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<ResponseModel> cancelOrder(String orderID, String? reason) async {
    Map<String, String> data = {'_method': 'put', 'order_id': orderID, 'reason': reason!};
    if(AuthHelper.isGuestLoggedIn()){
      data.addAll({'guest_id': AuthHelper.getGuestId()});
    }
    Response response = await apiClient.postData(AppConstants.orderCancelUri, data);
    if(response.statusCode == 200) {
      return ResponseModel(true, response.body['message']);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<PaginatedDeliveryLogModel?> getSubscriptionDeliveryLog(int? subscriptionID, int offset) async {
    PaginatedDeliveryLogModel? deliverLogs;
    Response response = await apiClient.getData('${AppConstants.subscriptionListUri}/$subscriptionID/delivery-log?offset=$offset&limit=10');
    if (response.statusCode == 200) {
      deliverLogs = PaginatedDeliveryLogModel.fromJson(response.body);
    }
    return deliverLogs;
  }

  @override
  Future<PaginatedPauseLogModel?> getSubscriptionPauseLog(int? subscriptionID, int offset) async {
    PaginatedPauseLogModel? pauseLogs;
    Response response = await apiClient.getData('${AppConstants.subscriptionListUri}/$subscriptionID/pause-log?offset=$offset&limit=10');
    if (response.statusCode == 200) {
      pauseLogs = PaginatedPauseLogModel.fromJson(response.body);
    }
    return pauseLogs;
  }

  @override
  Future<ResponseModel> updateSubscriptionStatus(int? subscriptionID, String? startDate, String? endDate, String status, String note, String? reason) async {
    Response response = await apiClient.postData(
      '${AppConstants.subscriptionListUri}/$subscriptionID',
      {'_method': 'put', 'status': status, 'note': note, 'cancellation_reason': reason, 'start_date': startDate, 'end_date': endDate},
    );
    if(response.statusCode == 200) {
      return ResponseModel(true, response.statusText);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Response> get(String? id, {String? guestId}) async {
    return await apiClient.getData('${AppConstants.orderDetailsUri}$id${guestId != null ? '&guest_id=$guestId' : ''}');
  }



  @override
  Future<PaginatedOrderModel?> getList({int? offset, String? guestId, bool isRunningOrder = false, bool isSubscriptionOrder = false}) {
    if(isRunningOrder) {
      return _getRunningOrderList(offset!, guestId);
    }
    else if(isSubscriptionOrder) {
      return _getRunningSubscriptionOrderList(offset!);
    }
    else {
      return _getHistoryOrderList(offset!);
    }
  }

  Future<PaginatedOrderModel?> _getRunningOrderList(int offset, String? guestId) async {
    PaginatedOrderModel? paginateOrderModel;
    Response response = await apiClient.getData('${AppConstants.runningOrderListUri}?offset=$offset&limit=${100}${guestId != null ? '&guest_id=$guestId' : ''}');
    if (response.statusCode == 200) {
      paginateOrderModel = PaginatedOrderModel.fromJson(response.body);
    }
    return paginateOrderModel;
  }

  Future<PaginatedOrderModel?> _getRunningSubscriptionOrderList(int offset) async {
    PaginatedOrderModel? paginateOrderModel;
    Response response = await apiClient.getData('${AppConstants.runningSubscriptionOrderListUri}?offset=$offset&limit=${100}');
    if (response.statusCode == 200) {
      paginateOrderModel = PaginatedOrderModel.fromJson(response.body);
    }
    return paginateOrderModel;
  }

  Future<PaginatedOrderModel?> _getHistoryOrderList(int offset) async {
    PaginatedOrderModel? paginateOrderModel;
    Response response = await apiClient.getData('${AppConstants.historyOrderListUri}?offset=$offset&limit=10');
    if (response.statusCode == 200) {
      paginateOrderModel = PaginatedOrderModel.fromJson(response.body);
    }
    return paginateOrderModel;
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  
}