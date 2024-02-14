import 'package:stackfood_multivendor/features/checkout/widgets/payment_failed_dialog.dart';
import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/location/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderSuccessfulDialogWidget extends StatefulWidget {
  final String? orderID;
  final String? contactNumber;
  const OrderSuccessfulDialogWidget({super.key, required this.orderID, this.contactNumber});

  @override
  State<OrderSuccessfulDialogWidget> createState() => _OrderSuccessfulDialogWidgetState();
}

class _OrderSuccessfulDialogWidgetState extends State<OrderSuccessfulDialogWidget> {

  @override
  void initState() {
    super.initState();
    Get.find<OrderController>().trackOrder(widget.orderID.toString(), null, false, contactNumber: widget.contactNumber);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvoked: (val) async{
        await Get.offAllNamed(RouteHelper.getInitialRoute());
      },
      child: GetBuilder<OrderController>(builder: (orderController){
          double total = 0;
          bool success = true;
          double? maximumCodOrderAmount;
          if(orderController.trackModel != null) {
            ZoneData zoneData = AddressHelper.getAddressFromSharedPref()!.zoneData!.firstWhere((data) => data.id == AddressHelper.getAddressFromSharedPref()!.zoneId);
            maximumCodOrderAmount = zoneData.maxCodOrderAmount;
            total = ((orderController.trackModel!.orderAmount! / 100) * Get.find<SplashController>().configModel!.loyaltyPointItemPurchasePoint!);
            success = orderController.trackModel!.paymentStatus == 'paid' || orderController.trackModel!.paymentMethod == 'cash_on_delivery' || orderController.trackModel!.paymentMethod == 'partial_payment';

            if (!success && !Get.isDialogOpen! && orderController.trackModel!.orderStatus != 'canceled' && Get.currentRoute.startsWith(RouteHelper.orderSuccess)) {
              Future.delayed(const Duration(seconds: 1), () {
                Get.dialog(PaymentFailedDialog(orderID: widget.orderID, orderAmount: total, maxCodOrderAmount: maximumCodOrderAmount), barrierDismissible: false);
              });
            }
          }

          return orderController.trackModel != null ? Center(
            child: Container(
              width: 500,  height: 390,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                ResponsiveHelper.isDesktop(context) ? Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.clear),
                  ),
                ) : const SizedBox(),

                const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                Image.asset(success ? Images.checked : Images.warning, width: 55, height: 55 ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text(
                  success ? 'you_placed_the_order_successfully'.tr : 'your_order_is_failed_to_place'.tr,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Text(
                  '${'order_id'.tr}: ${widget.orderID}',
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                  child: Text(
                    success ? 'your_order_is_placed_successfully'.tr : 'your_order_is_failed_to_place_because'.tr,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                // const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                //
                // Padding(
                //   padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                //   child: CustomButton( width: 400, height: 55, buttonText: 'back_to_home'.tr, isBold: false, onPressed: () => Get.offAllNamed(RouteHelper.getInitialRoute())),
                // ),

            ])),
          ) : const Center(child: CircularProgressIndicator());
        })
    );
  }
}