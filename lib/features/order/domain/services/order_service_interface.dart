
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/place_order_body_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/delivery_log_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_cancellation_body.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_details_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/pause_log_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/subscription_schedule_model.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';

abstract class OrderServiceInterface {
  Future<PaginatedOrderModel?> getRunningOrderList(int offset, String? guestId);
  Future<PaginatedOrderModel?> getRunningSubscriptionOrderList(int offset);
  Future<PaginatedOrderModel?> getHistoryOrderList(int offset);
  Future<OrderModel?> trackOrder(String? orderID, String? guestId, {String? contactNumber});
  Future<List<CancellationData>?> getCancelReasons();
  Future<Response> getOrderDetails(String orderID, String? guestId);
  List<OrderDetailsModel>? processOrderDetails(Response response);
  List<SubscriptionScheduleModel>? processSchedules(Response response);
  Future<ResponseModel> switchToCOD(String? orderID);
  Future<List<Product>?> getFoodsFromFoodIds(List<int?> ids);
  List<int?> prepareFoodIds(List<OrderDetailsModel> orderedFoods);
  List<OnlineCart> prepareOnlineCartList(int? restaurantZoneId, List<OrderDetailsModel> orderedFoods, List<Product> foods);
  List<CartModel> prepareOfflineCartList(int? restaurantZoneId, List<OrderDetailsModel> orderedFoods, List<Product> foods);
  Future<bool> checkProductVariationHasChanged(List<CartModel> cartList);
  Future<List<String?>?> getRefundReasons();
  Map<String, String> prepareReasonData(String note, String? orderId, String reason);
  Future<ResponseModel> submitRefundRequest(Map<String, String> body, XFile? data, String? guestId);
  Future<ResponseModel> cancelOrder(String orderID, String? reason);
  OrderModel? findOrder(List<OrderModel>? runningOrderList, int? orderID);
  Future<PaginatedDeliveryLogModel?> getSubscriptionDeliveryLog(int? subscriptionID, int offset);
  Future<PaginatedPauseLogModel?> getSubscriptionPauseLog(int? subscriptionID, int offset);
  Future<ResponseModel> updateSubscriptionStatus(int? subscriptionID, String? startDate, String? endDate, String status, String note, String? reason);
}