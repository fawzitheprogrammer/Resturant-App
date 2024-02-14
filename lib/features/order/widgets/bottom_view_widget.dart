import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/order/widgets/cancellation_dialogue.dart';
import 'package:stackfood_multivendor/features/order/widgets/subscription_pause_dialog.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_details_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/features/review/screens/rate_review_screen.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomViewWidget extends StatelessWidget {
  final OrderController orderController;
  final OrderModel order;
  final int? orderId;
  final double total;
  final String? contactNumber;
  const BottomViewWidget({super.key, required this.orderController, required this.order, this.orderId, required this.total, this.contactNumber });

  @override
  Widget build(BuildContext context) {
    bool subscription = order.subscription != null;

    bool pending = order.orderStatus == AppConstants.pending;
    bool accepted = order.orderStatus == AppConstants.accepted;
    bool confirmed = order.orderStatus == AppConstants.confirmed;
    bool processing = order.orderStatus == AppConstants.processing;
    bool pickedUp = order.orderStatus == AppConstants.pickedUp;
    bool delivered = order.orderStatus == AppConstants.delivered;
    bool cancelled = order.orderStatus == AppConstants.cancelled;
    bool cod = order.paymentMethod == 'cash_on_delivery';
    bool digitalPay = order.paymentMethod == 'digital_payment';
    bool offlinePay = order.paymentMethod == 'offline_payment';

    return Column(children: [
      !orderController.showCancelled ? Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth + 20,
          child: Row(children: [
            ((!subscription || (order.subscription!.status != 'canceled' && order.subscription!.status != 'completed')) && ((pending && !digitalPay) || accepted || confirmed
            || processing || order.orderStatus == 'handover'|| pickedUp)) ? Expanded(
              child: CustomButtonWidget(
                buttonText: subscription ? 'track_subscription'.tr : 'track_order'.tr,
                margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                onPressed: () async {
                  orderController.cancelTimer();
                  await Get.toNamed(RouteHelper.getOrderTrackingRoute(order.id, contactNumber));
                  orderController.callTrackOrderApi(orderModel: order, orderId: orderId.toString(), contactNumber: contactNumber);
                },
              ),
            ) : const SizedBox(),

            (!offlinePay && pending && order.paymentStatus == 'unpaid' && digitalPay && Get.find<SplashController>().configModel!.cashOnDelivery!) ?
            Expanded(
              child: CustomButtonWidget(
                buttonText: 'switch_to_cash_on_delivery'.tr,
                margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                onPressed: () {
                  Get.dialog(ConfirmationDialogWidget(
                      icon: Images.warning, description: 'are_you_sure_to_switch'.tr,
                      onYesPressed: () {
                        double maxCodOrderAmount = AddressHelper.getAddressFromSharedPref()!.zoneData!.firstWhere((data) => data.id == order.restaurant!.zoneId).maxCodOrderAmount
                            ?? 0;

                        if(maxCodOrderAmount > total){
                          orderController.switchToCOD(order.id.toString(), null).then((isSuccess) {
                            Get.back();
                            if(isSuccess) {
                              Get.back();
                            }
                          });
                        }else{
                          if(Get.isDialogOpen!) {
                            Get.back();
                          }
                          showCustomSnackBar('${'you_cant_order_more_then'.tr} ${PriceConverter.convertPrice(maxCodOrderAmount)} ${'in_cash_on_delivery'.tr}');
                        }
                      }
                  ));
                },
              ),
            ): const SizedBox(),

            (subscription ? (order.subscription!.status == 'active' || order.subscription!.status == 'paused')
            : (pending)) ? Expanded(child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: TextButton(
                style: TextButton.styleFrom(minimumSize: const Size(1, 50), shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  side: BorderSide(width: 2, color: Theme.of(context).disabledColor),
                )),
                onPressed: () {
                  if(subscription) {
                    Get.dialog(SubscriptionPauseDialog(subscriptionID: order.subscriptionId, isPause: false));
                  }else {
                    orderController.setOrderCancelReason('');
                    Get.dialog(CancellationDialogue(orderId: order.id));
                  }
                },
                child: Text(subscription ? 'cancel_subscription'.tr : 'cancel_order'.tr, style: robotoBold.copyWith(
                  color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeDefault,
                )),
              ),
            )) : const SizedBox(),

          ]),
        ),
      ) : Center(
        child: Container(
          width: Dimensions.webMaxWidth,
          height: 50,
          margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
          child: Text('order_cancelled'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
        ),
      ),

      !orderController.showCancelled && subscription && (order.subscription!.status == 'active' || order.subscription!.status == 'paused') ? CustomButtonWidget(
        buttonText: 'pause_subscription'.tr,
        margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        onPressed: () async {
          Get.dialog(SubscriptionPauseDialog(subscriptionID: order.subscriptionId, isPause: true));
        },
      ) : const SizedBox(),

      Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
            child: !orderController.isLoading ? Get.find<AuthController>().isLoggedIn() ? Row(
              children: [
                (!subscription && delivered && orderController.orderDetails![0].itemCampaignId == null) ? Expanded(
                  child: CustomButtonWidget(
                    buttonText: 'review'.tr,
                    onPressed: () async {
                      List<OrderDetailsModel> orderDetailsList = [];
                      List<int?> orderDetailsIdList = [];
                      for (var orderDetail in orderController.orderDetails!) {
                        if(!orderDetailsIdList.contains(orderDetail.foodDetails!.id)) {
                          orderDetailsList.add(orderDetail);
                          orderDetailsIdList.add(orderDetail.foodDetails!.id);
                        }
                      }
                      orderController.cancelTimer();
                      await Get.toNamed(RouteHelper.getReviewRoute(), arguments: RateReviewScreen(
                        orderDetailsList: orderDetailsList, deliveryMan: order.deliveryMan,
                      ));
                      orderController.callTrackOrderApi(orderModel: order, orderId: orderId.toString(), contactNumber: contactNumber);
                    },
                  ),
                ) : const SizedBox(),
                SizedBox(width: cancelled || order.orderStatus == 'failed' ? 0 : Dimensions.paddingSizeSmall),

                !subscription && Get.find<SplashController>().configModel!.repeatOrderOption! && (delivered || cancelled || order.orderStatus == 'failed' || order.orderStatus == 'refund_request_canceled')
                ? Expanded(
                  child: CustomButtonWidget(
                    buttonText: 'reorder'.tr,
                    onPressed: () => orderController.reOrder(orderController.orderDetails!, order.restaurant!.zoneId),
                  ),
                ) : const SizedBox(),
              ],
            ) : const SizedBox() : const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),


      (!offlinePay && (order.orderStatus == 'failed' || cancelled) && !cod && Get.find<SplashController>().configModel!.cashOnDelivery!) ? Center(
        child: Container(
          width: Dimensions.webMaxWidth,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: CustomButtonWidget(
            buttonText: 'switch_to_cash_on_delivery'.tr,
            onPressed: () {
              Get.dialog(ConfirmationDialogWidget(
                  icon: Images.warning, description: 'are_you_sure_to_switch'.tr,
                  onYesPressed: () {
                    double? maxCodOrderAmount = AddressHelper.getAddressFromSharedPref()!.zoneData!.firstWhere((data) => data.id == order.restaurant!.zoneId).maxCodOrderAmount;

                    if(maxCodOrderAmount == null || maxCodOrderAmount > total){
                      orderController.switchToCOD(order.id.toString(), null).then((isSuccess) {
                        Get.back();
                        if(isSuccess) {
                          Get.back();
                        }
                      });
                    }else{
                      if(Get.isDialogOpen!) {
                        Get.back();
                      }
                      showCustomSnackBar('${'you_cant_order_more_then'.tr} ${PriceConverter.convertPrice(maxCodOrderAmount)} ${'in_cash_on_delivery'.tr}');
                    }
                  }
              ));
            },
          ),
        ),
      ) : const SizedBox(),
    ]);
  }
}
