import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/coupon_section.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/delivery_man_tips_section.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/delivery_option_button.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/delivery_section.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/order_type_widget.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/partial_pay_view.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/payment_section.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/subscription_view.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/time_slot_section.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class TopSectionWidget extends StatelessWidget {
  final double charge;
  final double deliveryCharge;
  final LocationController locationController;
  final bool tomorrowClosed;
  final bool todayClosed;
  final double price;
  final double discount;
  final double addOns;
  final bool restaurantSubscriptionActive;
  final bool showTips;
  final bool isCashOnDeliveryActive;
  final bool isDigitalPaymentActive;
  final bool isOfflinePaymentActive;
  final bool isWalletActive;
  final bool fromCart;
  final double total;
  final JustTheController tooltipController3;
  final JustTheController tooltipController2;
  final TextEditingController guestNameTextEditingController;
  final TextEditingController guestNumberTextEditingController;
  final TextEditingController guestEmailController;
  final FocusNode guestNumberNode;
  final FocusNode guestEmailNode;

  const TopSectionWidget({
    super.key, required this.charge, required this.deliveryCharge, required this.locationController,
    required this.tomorrowClosed, required this.todayClosed, required this.price, required this.discount,
    required this.addOns, required this.restaurantSubscriptionActive, required this.showTips,
    required this.isCashOnDeliveryActive, required this.isDigitalPaymentActive, required this.isWalletActive,
    required this.fromCart, required this.total, required this.tooltipController3, required this.tooltipController2,
    required this.guestNameTextEditingController, required this.guestNumberTextEditingController, required this.guestNumberNode,
    required this.isOfflinePaymentActive, required this.guestEmailController, required this.guestEmailNode});

  @override
  Widget build(BuildContext context) {
    bool takeAway = false;
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    bool isGuestLoggedIn = Get.find<AuthController>().isGuestLoggedIn();
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();

    return GetBuilder<CheckoutController>(
        builder: (checkoutController) {
          takeAway = (checkoutController.orderType == 'take_away');
          return Column(children: [

            SizedBox(height: !isDesktop && isCashOnDeliveryActive && restaurantSubscriptionActive ? Dimensions.paddingSizeSmall : 0),

            isCashOnDeliveryActive && restaurantSubscriptionActive && isLoggedIn ? Container(
              width: context.width,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, spreadRadius: 1, offset: const Offset(1, 2))],
              ),
              margin: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : Dimensions.fontSizeDefault),
              padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: isDesktop ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeLarge),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('order_type'.tr, style: robotoMedium),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Row(children: [
                  Expanded(child: OrderTypeWidget(
                    title: 'regular_order'.tr,
                    icon: Images.regularOrder,
                    isSelected: !checkoutController.subscriptionOrder,
                    onTap: () {
                      checkoutController.setSubscription(false);
                      if(checkoutController.isPartialPay){
                        checkoutController.changePartialPayment();
                      } else {
                        checkoutController.setPaymentMethod(-1);
                      }
                      checkoutController.updateTips(
                        Get.find<AuthController>().getDmTipIndex().isNotEmpty ? int.parse(Get.find<AuthController>().getDmTipIndex()) : 1, notify: false,
                      );
                    },
                  )),
                  SizedBox(width: isCashOnDeliveryActive ? Dimensions.paddingSizeSmall : 0),

                  Expanded(child: OrderTypeWidget(
                    title: 'subscription_order'.tr,
                    icon: Images.subscriptionOrder,
                    isSelected: checkoutController.subscriptionOrder,
                    onTap: () {
                      checkoutController.setSubscription(true);
                      checkoutController.addTips(0);
                      if(checkoutController.isPartialPay){
                        checkoutController.changePartialPayment();
                      } else {
                        checkoutController.setPaymentMethod(-1);
                      }
                    },
                  )),
                ]),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                checkoutController.subscriptionOrder ? SubscriptionView(
                  checkoutController: checkoutController,
                ) : const SizedBox(),
                SizedBox(height: checkoutController.subscriptionOrder ? Dimensions.paddingSizeLarge : 0),
              ]),
            ) : const SizedBox(),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            checkoutController.restaurant != null ? Container(
              width: context.width,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, spreadRadius: 1, offset: const Offset(1, 2))],
              ),
              margin: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : Dimensions.fontSizeDefault),
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text('delivery_option'.tr, style: robotoMedium),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [

                  (Get.find<SplashController>().configModel!.homeDelivery! && checkoutController.restaurant!.delivery!)
                      ? DeliveryOptionButton(
                    value: 'delivery', title: 'home_delivery'.tr, charge: charge,
                    isFree: checkoutController.restaurant!.freeDelivery, total: total,
                  ) : const SizedBox(),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  (Get.find<SplashController>().configModel!.takeAway! && checkoutController.restaurant!.takeAway!)
                      ? DeliveryOptionButton(
                    value: 'take_away', title: 'take_away'.tr, charge: deliveryCharge, isFree: true, total: total,
                  ) : const SizedBox(),

                ])),
                SizedBox(height: isDesktop ? Dimensions.paddingSizeDefault : 0),
              ]),
            ) : const SizedBox(),

            SizedBox(height: checkoutController.orderType != 'take_away' ? ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall),

            (checkoutController.orderType != 'take_away' && !ResponsiveHelper.isDesktop(context)) ? Center(child: Text('${'delivery_charge'.tr}: ${(checkoutController.orderType == 'take_away'
                || (checkoutController.orderType == 'delivery' ? checkoutController.restaurant!.freeDelivery! : true)) ? 'free'.tr
                : charge != -1 ? PriceConverter.convertPrice(checkoutController.orderType == 'delivery' ? charge : deliveryCharge)
                : 'calculating'.tr}', textDirection: TextDirection.ltr)) : const SizedBox(),

            SizedBox(height: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),

            /// Time Slot
            TimeSlotSection(fromCart: fromCart, checkoutController: checkoutController, tomorrowClosed: tomorrowClosed, todayClosed: todayClosed, tooltipController2: tooltipController2),

            ///Delivery Address
            DeliverySection(
              checkoutController: checkoutController,
              locationController: locationController, guestNameTextEditingController: guestNameTextEditingController,
              guestNumberTextEditingController: guestNumberTextEditingController, guestNumberNode: guestNumberNode,
              guestEmailController: guestEmailController, guestEmailNode: guestEmailNode,
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),


            /// Coupon
            !ResponsiveHelper.isDesktop(context) && !isGuestLoggedIn ? CouponSection(
              charge: charge, checkoutController: checkoutController, price: price,
              discount: discount, addOns: addOns, deliveryCharge: deliveryCharge, total: total,
            ) : const SizedBox(),
            SizedBox(height: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0),

            ///DmTips
            DeliveryManTipsSection(
              takeAway: takeAway, tooltipController3: tooltipController3, checkoutController: checkoutController,
              totalPrice: total, onTotalChange: (double price) => total + price,
            ),

            // SizedBox(height: (checkoutController.orderType != 'take_away' && Get.find<SplashController>().configModel!.dmTipsStatus == 1) ? Dimensions.paddingSizeExtraSmall : 0),

            ///payment..
            Column(children: [
              isDesktop ? PaymentSection(
                isCashOnDeliveryActive: isCashOnDeliveryActive, isDigitalPaymentActive: isDigitalPaymentActive,
                isWalletActive: isWalletActive, total: total, checkoutController: checkoutController, isOfflinePaymentActive: isOfflinePaymentActive,
              ) : const SizedBox(),
              // SizedBox(height: isGuestLoggedIn && !isDesktop ? 0 : Dimensions.paddingSizeDefault),

              !isDesktop && !isGuestLoggedIn ? PartialPayView(totalPrice: total) : const SizedBox(),

            ]),


            /*ResponsiveHelper.isDesktop(context) ? PaymentSection(
                isCashOnDeliveryActive: isCashOnDeliveryActive, isDigitalPaymentActive: isDigitalPaymentActive,
                isWalletActive: isWalletActive, total: total, checkoutController: checkoutController, isOfflinePaymentActive: isOfflinePaymentActive,
              ) : const SizedBox(),*/

            //SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),

            isDesktop ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('additional_note'.tr, style: robotoMedium),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              CustomTextFieldWidget(
                controller: checkoutController.noteController,
                titleText: 'ex_please_provide_extra_napkin'.tr,
                maxLines: 3,
                inputType: TextInputType.multiline,
                inputAction: TextInputAction.done,
                capitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),
            ]) : const SizedBox(),

          ]);
        }
    );
  }

  // void _checkPermission(Function onTap) async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if(permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //   }
  //   if(permission == LocationPermission.denied) {
  //     showCustomSnackBar('you_have_to_allow'.tr);
  //   }else if(permission == LocationPermission.deniedForever) {
  //     Get.dialog(const PermissionDialog());
  //   }else {
  //     onTap();
  //   }
  // }
}
