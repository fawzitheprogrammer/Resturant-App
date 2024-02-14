import 'dart:async';

import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/place_order_body_model.dart';
import 'package:stackfood_multivendor/features/loyalty/controllers/loyalty_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/delivery_log_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_cancellation_body.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_details_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/pause_log_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/subscription_schedule_model.dart';
import 'package:stackfood_multivendor/features/order/domain/services/order_service_interface.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/auth_helper.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class OrderController extends GetxController implements GetxService {
  final OrderServiceInterface orderServiceInterface;

  OrderController({required this.orderServiceInterface});

  List<int> _runningOffsetList = [];
  List<int> _runningSubscriptionOffsetList = [];
  List<int> _historyOffsetList = [];

  int _runningOffset = 1;
  int get runningOffset => _runningOffset;

  List<OrderModel>? _runningOrderList;
  List<OrderModel>? get runningOrderList => _runningOrderList;

  List<OrderModel>? _runningSubscriptionOrderList;
  List<OrderModel>? get runningSubscriptionOrderList => _runningSubscriptionOrderList;

  List<OrderModel>? _historyOrderList;
  List<OrderModel>? get historyOrderList => _historyOrderList;

  List<OrderDetailsModel>? _orderDetails;
  List<OrderDetailsModel>? get orderDetails => _orderDetails;

  int? _runningPageSize;
  int? get runningPageSize => _runningPageSize;

  bool _runningPaginate = false;
  bool get runningPaginate => _runningPaginate;

  int _runningSubscriptionOffset = 1;
  int get runningSubscriptionOffset => _runningSubscriptionOffset;

  int? _runningSubscriptionPageSize;
  int? get runningSubscriptionPageSize => _runningSubscriptionPageSize;

  bool _runningSubscriptionPaginate = false;
  bool get runningSubscriptionPaginate => _runningSubscriptionPaginate;

  int _historyOffset = 1;
  int get historyOffset => _historyOffset;

  int? _historyPageSize;
  int? get historyPageSize => _historyPageSize;

  bool _historyPaginate = false;
  bool get historyPaginate => _historyPaginate;

  Timer? _timer;

  bool _showCancelled = false;
  bool get showCancelled => _showCancelled;

  OrderModel? _trackModel;
  OrderModel? get trackModel => _trackModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CancellationData>? _orderCancelReasons;
  List<CancellationData>? get orderCancelReasons => _orderCancelReasons;

  List<SubscriptionScheduleModel>? _schedules;
  List<SubscriptionScheduleModel>? get schedules => _schedules;

  PaginatedDeliveryLogModel? _deliverLogs;
  PaginatedDeliveryLogModel? get deliveryLogs => _deliverLogs;

  PaginatedPauseLogModel? _pauseLogs;
  PaginatedPauseLogModel? get pauseLogs => _pauseLogs;

  bool _subscriveLoading = false;
  bool get subscriveLoading => _subscriveLoading;

  String? _cancelReason;
  String? get cancelReason => _cancelReason;

  bool _canReorder = true;
  String _reorderMessage = '';

  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  int _selectedReasonIndex = 0;
  int get selectedReasonIndex => _selectedReasonIndex;

  List<String?>? _refundReasons;
  List<String?>? get refundReasons => _refundReasons;

  XFile? _refundImage;
  XFile? get refundImage => _refundImage;

  int? _cancellationIndex = 0;
  int? get cancellationIndex => _cancellationIndex;

  bool _showBottomSheet = true;
  bool get showBottomSheet => _showBottomSheet;

  bool _showOneOrder = true;
  bool get showOneOrder => _showOneOrder;

  Future<void> getRunningOrders(int offset, {bool notify = true}) async {
    if(offset == 1) {
      _runningOffsetList = [];
      _runningOffset = 1;
      _runningOrderList = null;
      if(notify) {
        update();
      }
    }
    if (!_runningOffsetList.contains(offset)) {
      _runningOffsetList.add(offset);
      PaginatedOrderModel? paginatedOrderModel = await orderServiceInterface.getRunningOrderList(offset, AuthHelper.isLoggedIn() ? null : AuthHelper.getGuestId());
      if (paginatedOrderModel != null) {
        if (offset == 1) {
          _runningOrderList = [];
        }
        _runningOrderList!.addAll(paginatedOrderModel.orders!);
        _runningPageSize = paginatedOrderModel.totalSize;
        _runningPaginate = false;

        update();
      }
    } else {
      if(_runningPaginate) {
        _runningPaginate = false;
        update();
      }
    }
  }

  Future<void> getRunningSubscriptionOrders(int offset, {bool notify = true}) async {
    if(offset == 1) {
      _runningSubscriptionOffsetList = [];
      _runningSubscriptionOffset = 1;
      _runningSubscriptionOrderList = null;
      if(notify) {
        update();
      }
    }
    if (!_runningSubscriptionOffsetList.contains(offset)) {
      _runningSubscriptionOffsetList.add(offset);
      PaginatedOrderModel? paginatedOrderModel = await orderServiceInterface.getRunningSubscriptionOrderList(offset);
      if (paginatedOrderModel != null) {
        if (offset == 1) {
          _runningSubscriptionOrderList = [];
        }
        _runningSubscriptionOrderList!.addAll(paginatedOrderModel.orders!);
        _runningSubscriptionPageSize = paginatedOrderModel.totalSize;
        _runningSubscriptionPaginate = false;
        update();
      }
    } else {
      if(_runningSubscriptionPaginate) {
        _runningSubscriptionPaginate = false;
        update();
      }
    }
  }

  Future<void> getHistoryOrders(int offset, {bool notify = true}) async {
    if(offset == 1) {
      _historyOffsetList = [];
      _historyOrderList = null;
      if(notify) {
        update();
      }
    }
    _historyOffset = offset;
    if (!_historyOffsetList.contains(offset)) {
      _historyOffsetList.add(offset);
      PaginatedOrderModel? paginatedOrderModel = await orderServiceInterface.getHistoryOrderList(offset);
      if (paginatedOrderModel != null) {
        if (offset == 1) {
          _historyOrderList = [];
        }
        _historyOrderList!.addAll(paginatedOrderModel.orders!);
        _historyPageSize = paginatedOrderModel.totalSize;
        _historyPaginate = false;
        update();
      }
    } else {
      if(_historyPaginate) {
        _historyPaginate = false;
        update();
      }
    }
  }

  void setOffset(int offset, bool isRunning, bool isSubscription) {
    if(isRunning) {
      _runningOffset = offset;
    } else if(isSubscription) {
      _runningSubscriptionOffset = offset;
    } else {
      _historyOffset = offset;
    }
  }

  void showBottomLoader(bool isRunning, bool isSubscription) {
    if(isRunning) {
      _runningPaginate = true;
    } else if(isSubscription) {
      _runningSubscriptionPaginate = true;
    } else {
      _historyPaginate = true;
    }
    update();
  }

  void callTrackOrderApi({required OrderModel orderModel, required String orderId, String? contactNumber}){
    if(orderModel.orderStatus != 'delivered' && orderModel.orderStatus != 'failed' && orderModel.orderStatus != 'canceled') {
      timerTrackOrder(orderId.toString(), contactNumber: contactNumber);
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        if(Get.currentRoute.contains(RouteHelper.orderDetails)){
          timerTrackOrder(orderId.toString(), contactNumber: contactNumber);
        } else {
          _timer?.cancel();
        }
      });
    }else{
      timerTrackOrder(orderId.toString(), contactNumber: contactNumber);
    }
  }

  Future<bool> timerTrackOrder(String orderID, {String? contactNumber}) async {
    _showCancelled = false;
    OrderModel? orderModel = await orderServiceInterface.trackOrder(orderID, AuthHelper.isLoggedIn() ? null : AuthHelper.getGuestId(), contactNumber: contactNumber);
    if(orderModel != null) {
      _trackModel = orderModel;
    }
    update();
    return (orderModel != null);
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  Future<ResponseModel> trackOrder(String? orderID, OrderModel? orderModel, bool fromTracking, {String? contactNumber, bool? fromGuestInput = false}) async {
    _trackModel = null;
    if(!fromTracking) {
      _orderDetails = null;
    }
    _showCancelled = false;
    ResponseModel responseModel;
    if(orderModel == null) {
      _isLoading = true;

      OrderModel? responseOrderModel = await orderServiceInterface.trackOrder(orderID, AuthHelper.isLoggedIn() ? null : AuthHelper.getGuestId(), contactNumber: contactNumber);
      if (responseOrderModel != null) {
        _trackModel = responseOrderModel;
        responseModel = ResponseModel(true, 'Successful');
      } else {
        responseModel = ResponseModel(false, 'Failed');
      }
      _isLoading = false;
      update();
    }else {
      _trackModel = orderModel;
      responseModel = ResponseModel(true, 'Successful');
    }
    return responseModel;
  }

  Future<void> getDeliveryLogs(int? subscriptionID, int offset) async {
    if(offset == 1) {
      _deliverLogs = null;
    }
    PaginatedDeliveryLogModel? deliveryLogModel = await orderServiceInterface.getSubscriptionDeliveryLog(subscriptionID, offset);
    if (deliveryLogModel != null) {
      if (offset == 1) {
        _deliverLogs = deliveryLogModel;
      }else {
        _deliverLogs!.data!.addAll(deliveryLogModel.data!);
        _deliverLogs!.offset = deliveryLogModel.offset;
        _deliverLogs!.totalSize = deliveryLogModel.totalSize;
      }
      update();
    }
  }

  Future<void> getPauseLogs(int? subscriptionID, int offset) async {
    if(offset == 1) {
      _pauseLogs = null;
    }
    PaginatedPauseLogModel? pauseLogModel = await orderServiceInterface.getSubscriptionPauseLog(subscriptionID, offset);
    if (pauseLogModel != null) {
      if (offset == 1) {
        _pauseLogs = pauseLogModel;
      }else {
        _pauseLogs!.data!.addAll(pauseLogModel.data!);
        _pauseLogs!.offset = pauseLogModel.offset;
        _pauseLogs!.totalSize = pauseLogModel.totalSize;
      }
      update();
    }
  }

  void setCancelIndex(int? index) {
    _cancellationIndex = index;
    update();
  }

  Future<bool> updateSubscriptionStatus(int? subscriptionID, DateTime? startDate, DateTime? endDate, String status, String note, String? reason) async {
    _subscriveLoading = true;
    update();

    ResponseModel responseModel = await orderServiceInterface.updateSubscriptionStatus(
      subscriptionID, startDate != null ? DateConverter.dateToDateAndTime(startDate) : null,
      endDate != null ? DateConverter.dateToDateAndTime(endDate) : null, status, note, reason,
    );
    if (responseModel.isSuccess) {
      Get.back();
      if(status == 'canceled' || startDate!.isAtSameMomentAs(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
        _trackModel!.subscription!.status = status;
      }
      showCustomSnackBar(
        status == 'paused' ? 'subscription_paused_successfully'.tr : 'subscription_cancelled_successfully'.tr, isError: false,
      );
    }
    _subscriveLoading = false;
    update();
    return responseModel.isSuccess;
  }

  Future<void> getOrderCancelReasons()async {
    List<CancellationData>? reasons = await orderServiceInterface.getCancelReasons();
    if (reasons != null) {
      _orderCancelReasons = [];
      _orderCancelReasons!.addAll(reasons);
    }
    update();
  }

  Future<List<OrderDetailsModel>?> getOrderDetails(String orderID) async {
    _isLoading = true;
    _showCancelled = false;

    Response response = await orderServiceInterface.getOrderDetails(orderID, AuthHelper.isLoggedIn() ? null : AuthHelper.getGuestId());
    if (response.statusCode == 200) {
      _orderDetails = orderServiceInterface.processOrderDetails(response);
      _schedules = orderServiceInterface.processSchedules(response);
    }
    _isLoading = false;
    update();
    return _orderDetails;
  }

  Future<bool> switchToCOD(String? orderID, String? contactNumber, {double? points}) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await orderServiceInterface.switchToCOD(orderID);
    if (responseModel.isSuccess) {
      if(points != null) {
        Get.find<LoyaltyController>().saveEarningPoint(points.toStringAsFixed(0));
      }
      if(Get.find<AuthController>().isGuestLoggedIn()) {
        Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID!, 'success', 0, contactNumber));
      }else {
        await Get.offAllNamed(RouteHelper.getInitialRoute());
      }
      showCustomSnackBar(responseModel.message, isError: false);
    }
    _isLoading = false;
    update();
    return responseModel.isSuccess;
  }

  void selectReason(int index,{bool isUpdate = true}){
    _selectedReasonIndex = index;
    if(isUpdate) {
      update();
    }
  }

  void setOrderCancelReason(String? reason){
    _cancelReason = reason;
    update();
  }

  void expandedUpdate(bool status){
    _isExpanded = status;
    update();
  }

  Future<void> getRefundReasons()async {
    _refundReasons = null;
    _refundReasons = await orderServiceInterface.getRefundReasons();
    update();
  }

  void pickRefundImage(bool isRemove) async {
    if(isRemove) {
      _refundImage = null;
    }else {
      _refundImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      update();
    }
  }

  void showRunningOrders(){
    _showBottomSheet = !_showBottomSheet;
    update();
  }

  void showOrders(){
    _showOneOrder = !_showOneOrder;
    update();
  }

  Future<void> submitRefundRequest(String note, String? orderId)async {
    if(_selectedReasonIndex == 0){
      showCustomSnackBar('please_select_reason'.tr);
    }else{
      _isLoading = true;
      update();
      Map<String, String> body = orderServiceInterface.prepareReasonData(note, orderId, _refundReasons![selectedReasonIndex]!);

      ResponseModel responseModel = await orderServiceInterface.submitRefundRequest(body, _refundImage, AuthHelper.isLoggedIn() ? null : AuthHelper.getGuestId());
      if (responseModel.isSuccess) {
        showCustomSnackBar(responseModel.message, isError: false);
        Get.offAllNamed(RouteHelper.getInitialRoute());
      }
      _isLoading = false;
      update();
    }
  }

  Future<bool> cancelOrder(int? orderID, String? cancelReason) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await orderServiceInterface.cancelOrder(orderID.toString(), cancelReason);
    _isLoading = false;
    Get.back();
    if (responseModel.isSuccess) {
      OrderModel? orderModel = orderServiceInterface.findOrder(_runningOrderList, orderID);
      _runningOrderList!.remove(orderModel);
      _showCancelled = true;
      showCustomSnackBar(responseModel.message, isError: false);
    }
    update();
    return responseModel.isSuccess;
  }

  Future<void> reOrder(List<OrderDetailsModel> orderedFoods, int? restaurantZoneId) async {
    _isLoading = true;
    update();

    List<int?> foodIds = orderServiceInterface.prepareFoodIds(orderedFoods);
    List<Product>? responseFoods = await orderServiceInterface.getFoodsFromFoodIds(foodIds);
    if (responseFoods != null) {
      _canReorder = true;
      List<Product> foods = responseFoods;

      List<OnlineCart> onlineCartList = orderServiceInterface.prepareOnlineCartList(restaurantZoneId, orderedFoods, foods);
      List<CartModel> offlineCartList = orderServiceInterface.prepareOfflineCartList(restaurantZoneId, orderedFoods, foods);

      _canReorder = AddressHelper.getAddressFromSharedPref()!.zoneIds!.contains(restaurantZoneId);
      _reorderMessage = !_canReorder ? 'you_are_not_in_the_order_zone' : '';

      if(_canReorder) {
        _canReorder = await orderServiceInterface.checkProductVariationHasChanged(offlineCartList);
        _reorderMessage = !_canReorder ? 'this_ordered_products_are_updated_so_can_not_reorder_this_order' : '';
      }

      _isLoading = false;
      update();

      if(_canReorder) {
        await Get.find<CartController>().reorderAddToCart(onlineCartList);
        Get.toNamed(RouteHelper.getCartRoute(fromReorder: true));
      }else{
        showCustomSnackBar(_reorderMessage.tr);
      }

    }

  }



}