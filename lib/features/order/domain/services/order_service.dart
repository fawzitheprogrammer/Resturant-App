import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart' as cart;
import 'package:stackfood_multivendor/features/checkout/domain/models/place_order_body_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/delivery_log_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_cancellation_body.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_details_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/pause_log_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/subscription_schedule_model.dart';
import 'package:stackfood_multivendor/features/order/domain/repositories/order_repository_interface.dart';
import 'package:stackfood_multivendor/features/order/domain/services/order_service_interface.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';

class OrderService implements OrderServiceInterface {
  final OrderRepositoryInterface orderRepositoryInterface;
  OrderService({required this.orderRepositoryInterface});

  @override
  Future<PaginatedOrderModel?> getRunningOrderList(int offset, String? guestId) async {
    return await orderRepositoryInterface.getList(offset: offset, guestId: guestId, isRunningOrder: true);
  }

  @override
  Future<PaginatedOrderModel?> getRunningSubscriptionOrderList(int offset) async {
    return await orderRepositoryInterface.getList(offset: offset, isSubscriptionOrder: true);
  }

  @override
  Future<PaginatedOrderModel?> getHistoryOrderList(int offset) async {
    return await orderRepositoryInterface.getList(offset: offset);
  }

  @override
  Future<OrderModel?> trackOrder(String? orderID, String? guestId, {String? contactNumber}) async {
    return await orderRepositoryInterface.trackOrder(orderID, guestId, contactNumber: contactNumber);
  }

  @override
  Future<List<CancellationData>?> getCancelReasons() async {
    return await orderRepositoryInterface.getCancelReasons();
  }

  @override
  Future<Response> getOrderDetails(String orderID, String? guestId) async {
    return await orderRepositoryInterface.get(orderID, guestId: guestId);
  }

  @override
  Future<PaginatedDeliveryLogModel?> getSubscriptionDeliveryLog(int? subscriptionID, int offset) async {
    return await orderRepositoryInterface.getSubscriptionDeliveryLog(subscriptionID, offset);
  }

  @override
  Future<PaginatedPauseLogModel?> getSubscriptionPauseLog(int? subscriptionID, int offset) async {
    return await orderRepositoryInterface.getSubscriptionPauseLog(subscriptionID, offset);
  }

  @override
  Future<ResponseModel> updateSubscriptionStatus(int? subscriptionID, String? startDate, String? endDate, String status, String note, String? reason) async {
    return await orderRepositoryInterface.updateSubscriptionStatus(subscriptionID, startDate, endDate, status, note, reason);
  }

  @override
  List<OrderDetailsModel>? processOrderDetails(Response response) {
    List<OrderDetailsModel>? orderDetails = [];
    if(response.body['details'] != null){
      response.body['details'].forEach((orderDetail) => orderDetails.add(OrderDetailsModel.fromJson(orderDetail)));
    }
    return orderDetails;
  }

  @override
  List<SubscriptionScheduleModel>? processSchedules(Response response) {
    List<SubscriptionScheduleModel>? schedules = [];
    if(response.body['subscription_schedules'] != null){
      response.body['subscription_schedules'].forEach((schedule) => schedules.add(SubscriptionScheduleModel.fromJson(schedule)));
    }
    return schedules;
  }

  @override
  Future<ResponseModel> switchToCOD(String? orderID) async{
    return await orderRepositoryInterface.switchToCOD(orderID);
  }

  @override
  Future<List<Product>?> getFoodsFromFoodIds(List<int?> ids) async{
    return await orderRepositoryInterface.getFoodsFromFoodIds(ids);
  }

  @override
  Future<List<String?>?> getRefundReasons() async {
    return await orderRepositoryInterface.getRefundReasons();
  }

  @override
  Map<String, String> prepareReasonData(String note, String? orderId, String reason) {
    Map<String, String> body = {};
    body.addAll(<String, String>{
      'customer_reason': reason,
      'order_id': orderId!,
      'customer_note': note,
    });
    return body;
  }

  @override
  Future<ResponseModel> submitRefundRequest(Map<String, String> body, XFile? data, String? guestId) async {
    return await orderRepositoryInterface.submitRefundRequest(body, data, guestId);
  }

  @override
  Future<ResponseModel> cancelOrder(String orderID, String? reason) async {
    return await orderRepositoryInterface.cancelOrder(orderID, reason);
  }

  @override
  OrderModel? findOrder(List<OrderModel>? runningOrderList, int? orderID) {
    OrderModel? orderModel;
    for(OrderModel order in runningOrderList!) {
      if(order.id == orderID) {
        orderModel = order;
        break;
      }
    }
    return orderModel;
  }

  @override
  List<int?> prepareFoodIds(List<OrderDetailsModel> orderedFoods) {
    List<int?> foodIds = [];
    for(int i=0; i<orderedFoods.length; i++){
      foodIds.add(orderedFoods[i].foodDetails!.id);
    }
    return foodIds;
  }

  @override
  List<OnlineCart> prepareOnlineCartList(int? restaurantZoneId, List<OrderDetailsModel> orderedFoods, List<Product> foods) {
    List<OnlineCart> onlineCartList = [];
    if(AddressHelper.getAddressFromSharedPref()!.zoneIds!.contains(restaurantZoneId)){
      for(int i=0; i < orderedFoods.length; i++){
        for(int j=0; j<foods.length; j++){
          if(orderedFoods[i].foodDetails!.id == foods[j].id){
            onlineCartList.add(_sortOutProductAddToCard(orderedFoods[i].variation, foods[j], orderedFoods[i], getOnlineCart: true));
          }
        }
      }
    }
    return onlineCartList;
  }

  @override
  List<CartModel> prepareOfflineCartList(int? restaurantZoneId, List<OrderDetailsModel> orderedFoods, List<Product> foods) {
    List<CartModel> offlineCartList = [];
    if(AddressHelper.getAddressFromSharedPref()!.zoneIds!.contains(restaurantZoneId)){
      for(int i=0; i < orderedFoods.length; i++){
        for(int j=0; j<foods.length; j++){
          if(orderedFoods[i].foodDetails!.id == foods[j].id){
            offlineCartList.add(_sortOutProductAddToCard(orderedFoods[i].variation, foods[j], orderedFoods[i], getOnlineCart: false));
          }
        }
      }
    }
    return offlineCartList;
  }

  dynamic _sortOutProductAddToCard(List<Variation>? orderedVariation, Product currentFood, OrderDetailsModel orderDetailsModel, {bool getOnlineCart = true}){
    List<List<bool?>> selectedVariations = [];

    double price = currentFood.price!;
    double variationPrice = 0;
    int? quantity = orderDetailsModel.quantity;
    List<int?> addOnIdList = [];
    List<cart.AddOn> addOnIdWithQtnList = [];
    List<bool> addOnActiveList = [];
    List<int?> addOnQtyList = [];
    List<AddOns> addOnsList = [];
    List<OrderVariation> variations = [];

    if(currentFood.variations != null && currentFood.variations!.isNotEmpty){
      for(int i=0; i<currentFood.variations!.length; i++){
        selectedVariations.add([]);
        for(int j=0; j<orderedVariation!.length; j++){
          if(currentFood.variations![i].name == orderedVariation[j].name){
            for(int x=0; x<currentFood.variations![i].variationValues!.length; x++){
              selectedVariations[i].add(false);
              for(int y=0; y<orderedVariation[j].variationValues!.length; y++){
                if(currentFood.variations![i].variationValues![x].level == orderedVariation[j].variationValues![y].level){
                  selectedVariations[i][x] = true;
                }
              }
            }
          }
        }
      }
    }

    if(currentFood.variations != null && currentFood.variations!.isNotEmpty){
      for(int i=0; i<currentFood.variations!.length; i++){
        if(selectedVariations[i].contains(true)){
          variations.add(OrderVariation(name: currentFood.variations![i].name, values: OrderVariationValue(label: [])));
          for(int j=0; j<currentFood.variations![i].variationValues!.length; j++) {
            if(selectedVariations[i][j]!) {
              variations[variations.length-1].values!.label!.add(currentFood.variations![i].variationValues![j].level);
            }
          }
        }
      }
    }

    if(currentFood.variations != null){
      for(int index = 0; index< currentFood.variations!.length; index++) {
        for(int i=0; i<currentFood.variations![index].variationValues!.length; i++) {
          if(selectedVariations[index].isNotEmpty && selectedVariations[index][i]!) {
            variationPrice += currentFood.variations![index].variationValues![i].optionPrice!;
          }
        }
      }
    }

    for (var addon in currentFood.addOns!) {
      for(int i=0; i<orderDetailsModel.addOns!.length; i++){
        if(orderDetailsModel.addOns![i].id == addon.id){
          addOnIdList.add(addon.id);
          addOnIdWithQtnList.add(cart.AddOn(id: addon.id, quantity: orderDetailsModel.addOns![i].quantity));
        }
      }
      addOnsList.add(addon);
    }


    for (var addOn in currentFood.addOns!) {
      if(addOnIdList.contains(addOn.id)) {
        addOnActiveList.add(true);
        addOnQtyList.add(orderDetailsModel.addOns![addOnIdList.indexOf(addOn.id)].quantity);
      }else {
        addOnActiveList.add(false);
      }
    }

    double? discount = (currentFood.restaurantDiscount == 0) ? currentFood.discount : currentFood.restaurantDiscount;
    String? discountType = (currentFood.restaurantDiscount == 0) ? currentFood.discountType : 'percent';
    double? priceWithDiscount = PriceConverter.convertWithDiscount(price, discount, discountType);

    double priceWithVariation = price + variationPrice;


    CartModel cartModel = CartModel(
      null, priceWithVariation, priceWithDiscount, (price - PriceConverter.convertWithDiscount(price, discount, discountType)!),
      quantity, addOnIdWithQtnList, addOnsList, false, currentFood, selectedVariations, currentFood.quantityLimit,
    );

    OnlineCart onlineCart = OnlineCart(
        null, currentFood.id, null,
        priceWithVariation.toString(), variations,
        quantity, addOnIdList, addOnsList, addOnQtyList, 'Food'
    );

    if(getOnlineCart) {
      return onlineCart;
    } else {
      return cartModel;
    }
  }

  @override
  Future<bool> checkProductVariationHasChanged(List<CartModel> cartList) async {
    bool canReorder = true;
    for(CartModel cart in cartList){
      if(cart.product!.variations != null && cart.product!.variations!.isNotEmpty){
        for (var pv in cart.product!.variations!) {
          int selectedValues = 0;

          if(pv.required!){
            for (var selected in cart.variations![cart.product!.variations!.indexOf(pv)]) {
              if(selected!){
                selectedValues = selectedValues + 1;
              }
            }

            if(selectedValues >= pv.min! && selectedValues<= pv.max! || (pv.min==0 && pv.max==0)){
              canReorder = true;
            } else{
              canReorder = false;
            }

          } else{
            for (var selected in cart.variations![cart.product!.variations!.indexOf(pv)]) {
              if(selected!){
                selectedValues = selectedValues + 1;
              }
            }

            if(selectedValues == 0){
              canReorder = true;
            } else{
              if((selectedValues >= pv.min! && selectedValues<= pv.max!) || (pv.min == 0 && pv.max == 0)){
                canReorder = true;
              } else{
                canReorder = false;
              }
            }
          }
        }
      }
    }

    return canReorder;
  }


}