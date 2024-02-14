import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/condition_check_box.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/coupon_section.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/order_place_button.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/partial_pay_view.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/payment_section.dart';
import 'package:stackfood_multivendor/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSectionWidget extends StatelessWidget {
  final bool isCashOnDeliveryActive;
  final bool isDigitalPaymentActive;
  final bool isOfflinePaymentActive;
  final bool isWalletActive;
  final double total;
  final double subTotal;
  final double discount;
  final CouponController couponController;
  final bool taxIncluded;
  final double tax;
  final double deliveryCharge;
  final double charge;
  final CheckoutController checkoutController;
  final LocationController locationController;
  final bool todayClosed;
  final bool tomorrowClosed;
  final double orderAmount;
  final double? maxCodOrderAmount;
  final int subscriptionQty;
  final double taxPercent;
  final bool fromCart;
  final List<CartModel> cartList;
  final double price;
  final double addOns;
  final TextEditingController guestNameTextEditingController;
  final TextEditingController guestNumberTextEditingController;
  final TextEditingController guestEmailController;
  final FocusNode guestNumberNode;
  final FocusNode guestEmailNode;
  const BottomSectionWidget({
    super.key, required this.isCashOnDeliveryActive, required this.isDigitalPaymentActive,
    required this.isWalletActive, required this.total,
    required this.subTotal, required this.discount, required this.couponController,
    required this.taxIncluded, required this.tax, required this.deliveryCharge, required this.checkoutController,
    required this.locationController, required this.todayClosed, required this.tomorrowClosed,
    required this.orderAmount, this.maxCodOrderAmount, required this.subscriptionQty, required this.taxPercent,
    required this.fromCart, required this.cartList, required this.price, required this.addOns, required this.charge, required this.guestNameTextEditingController,
    required this.guestNumberTextEditingController, required this.guestNumberNode, required this.isOfflinePaymentActive, required this.guestEmailController, required this.guestEmailNode,
  });

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    bool isGuestLoggedIn = Get.find<AuthController>().isGuestLoggedIn();
    return Container(
      decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, spreadRadius: 1, offset: const Offset(1, 2))],

      ) : null,
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        !ResponsiveHelper.isDesktop(context) ? PaymentSection(
          isCashOnDeliveryActive: isCashOnDeliveryActive, isDigitalPaymentActive: isDigitalPaymentActive,
          isWalletActive: isWalletActive, total: total, checkoutController: checkoutController, isOfflinePaymentActive: isOfflinePaymentActive,
        ) : const SizedBox(),
        const SizedBox(height: Dimensions.paddingSizeSmall),


        ResponsiveHelper.isDesktop(context) ? Padding(
          padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, bottom:Dimensions.paddingSizeSmall),
          child: Text('order_summary'.tr, style: robotoBold),
        ) : const SizedBox(),

        /// Coupon
        ResponsiveHelper.isDesktop(context) && !isGuestLoggedIn ? CouponSection(
          checkoutController: checkoutController, price: price, charge: charge,
          discount: discount, addOns: addOns, deliveryCharge: deliveryCharge, total: total,
        ) : const SizedBox(),
        SizedBox(height: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0),

        isDesktop && !isGuestLoggedIn ? PartialPayView(totalPrice: total) : const SizedBox(),

        ResponsiveHelper.isDesktop(context) ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
          child: pricingView(context),
        ) : const SizedBox(),

        !ResponsiveHelper.isDesktop(context) ? Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

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


            pricingView(context),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            const CheckoutCondition(),
          ]),
        ) : const SizedBox(),

        ResponsiveHelper.isDesktop(context) ? const Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: CheckoutCondition(),
        ) : const SizedBox(),

        ResponsiveHelper.isDesktop(context) ? Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    'total_amount'.tr,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                  ),
                  PriceConverter.convertAnimationPrice(
                    total,
                    textStyle: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                  ),
                ]),
              ),

              OrderPlaceButton(
                checkoutController: checkoutController, locationController: locationController,
                todayClosed: todayClosed, tomorrowClosed: tomorrowClosed, orderAmount: orderAmount, deliveryCharge: deliveryCharge,
                tax: tax, discount: discount, total: total, maxCodOrderAmount: maxCodOrderAmount, subscriptionQty: subscriptionQty,
                cartList: cartList, isCashOnDeliveryActive: isCashOnDeliveryActive, isDigitalPaymentActive: isDigitalPaymentActive,
                isWalletActive: isWalletActive, fromCart: fromCart, guestNumberTextEditingController: guestNumberTextEditingController,
                guestNameTextEditingController: guestNameTextEditingController, guestNumberNode: guestNumberNode, isOfflinePaymentActive: isOfflinePaymentActive,
                guestEmailController: guestEmailController, guestEmailNode: guestEmailNode,
                couponController: couponController, subTotal: subTotal, taxIncluded: taxIncluded, taxPercent: taxPercent,
              ),
            ],
          ),
          // child: orderPlaceButton(
          //     checkoutController, restaurantController, locationController, todayClosed, tomorrowClosed, orderAmount, deliveryCharge, tax, discount, total, maxCodOrderAmount, subscriptionQty
          // ),
        ) : const SizedBox(),
      ]),
    );
  }


  Widget pricingView(BuildContext context) {
    return Container(
      decoration: !ResponsiveHelper.isDesktop(context) ? BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, spreadRadius: 1, offset: const Offset(1, 2))],
      ) : null,
      padding: !ResponsiveHelper.isDesktop(context) ? const EdgeInsets.all(Dimensions.paddingSizeSmall) : EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        !ResponsiveHelper.isDesktop(context) ? Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('order_summary'.tr, style: robotoMedium),
            const SizedBox(height: 24),
          ]),

          Divider(thickness: 1, color: Theme.of(context).hintColor.withOpacity(0.5)),
        ]) : const SizedBox(),
        SizedBox(height: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(!checkoutController.subscriptionOrder ? 'subtotal'.tr : 'item_price'.tr, style: robotoRegular),
          Text(PriceConverter.convertPrice(subTotal), style: robotoRegular, textDirection: TextDirection.ltr),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('discount'.tr, style: robotoRegular),
          Row(children: [
            Text('(-) ', style: robotoRegular),
            PriceConverter.convertAnimationPrice(discount, textStyle: robotoRegular)
          ]),
          // Text('(-) ${PriceConverter.convertPrice(discount)}', style: robotoRegular, textDirection: TextDirection.ltr),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        (couponController.discount! > 0 || couponController.freeDelivery) ? Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('coupon_discount'.tr, style: robotoRegular),
            (couponController.coupon != null && couponController.coupon!.couponType == 'free_delivery') ? Text(
              'free_delivery'.tr, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor),
            ) : Row(children: [
              Text('(-) ', style: robotoRegular),
              Text(
                PriceConverter.convertPrice(couponController.discount),
                style: robotoRegular, textDirection: TextDirection.ltr,
              )
            ]),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),
        ]) : const SizedBox(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Text('${'vat_tax'.tr} ${taxIncluded ? 'tax_included'.tr : ''}', style: robotoRegular),
            Text('($taxPercent%)', style: robotoRegular, textDirection: TextDirection.ltr),
          ]),
          Row(children: [
            Text('(+) ', style: robotoRegular),
            Text(PriceConverter.convertPrice(tax), style: robotoRegular, textDirection: TextDirection.ltr),
          ]),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        (checkoutController.orderType != 'take_away' && Get.find<SplashController>().configModel!.dmTipsStatus == 1 && !checkoutController.subscriptionOrder) ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('delivery_man_tips'.tr, style: robotoRegular),
            Row(children: [
              Text('(+) ', style: robotoRegular),
              PriceConverter.convertAnimationPrice(checkoutController.tips, textStyle: robotoRegular)
            ]),
            // Text('(+) ${PriceConverter.convertPrice(checkoutController.tips)}', style: robotoRegular, textDirection: TextDirection.ltr),
          ],
        ) : const SizedBox.shrink(),
        SizedBox(height: checkoutController.orderType != 'take_away' && Get.find<SplashController>().configModel!.dmTipsStatus == 1 && !checkoutController.subscriptionOrder ? Dimensions.paddingSizeSmall : 0.0),

        checkoutController.orderType != 'take_away' ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('delivery_fee'.tr, style: robotoRegular),
          checkoutController.distance == -1 ? Text(
            'calculating'.tr, style: robotoRegular.copyWith(color: Colors.red),
          ) : (deliveryCharge == 0 || (couponController.coupon != null && couponController.coupon!.couponType == 'free_delivery')) ? Text(
            'free'.tr, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor),
          ) : Row(children: [
            Text('(+) ', style: robotoRegular),
            Text(
              PriceConverter.convertPrice(deliveryCharge), style: robotoRegular, textDirection: TextDirection.ltr,
            )
          ]),
        ]) : const SizedBox(),
        SizedBox(height: Get.find<SplashController>().configModel!.additionalChargeStatus! ? Dimensions.paddingSizeSmall : 0),

        Get.find<SplashController>().configModel!.additionalChargeStatus! ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(Get.find<SplashController>().configModel!.additionalChargeName!, style: robotoRegular),
          Text(
            '(+) ${PriceConverter.convertPrice(Get.find<SplashController>().configModel!.additionCharge)}',
            style: robotoRegular, textDirection: TextDirection.ltr,
          ),
        ]) : const SizedBox(),

        (ResponsiveHelper.isDesktop(context) || checkoutController.isPartialPay) ? Column(
          children: [
            Divider(thickness: 1, color: Theme.of(context).hintColor.withOpacity(0.5)),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                checkoutController.subscriptionOrder ? 'subtotal'.tr : 'total_amount'.tr,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: checkoutController.isPartialPay ? Theme.of(context).textTheme.bodyMedium!.color : Theme.of(context).primaryColor),
              ),
              PriceConverter.convertAnimationPrice(
                total,
                textStyle: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: checkoutController.isPartialPay ? Theme.of(context).textTheme.bodyMedium!.color : Theme.of(context).primaryColor),
              ),
            ]),
          ],
        ) : const SizedBox(),

        checkoutController.subscriptionOrder ? Column(children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('subscription_order_count'.tr, style: robotoMedium),
            Text(subscriptionQty.toString(), style: robotoMedium),
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            child: Divider(thickness: 1, color: Theme.of(context).hintColor.withOpacity(0.5)),
          ),

        ]) : const SizedBox(),
        SizedBox(height: checkoutController.isPartialPay ? Dimensions.paddingSizeSmall : 0),

        checkoutController.isPartialPay && !checkoutController.subscriptionOrder ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('paid_by_wallet'.tr, style: robotoRegular),
          Text('(-) ${PriceConverter.convertPrice(Get.find<ProfileController>().userInfoModel!.walletBalance!)}', style: robotoRegular, textDirection: TextDirection.ltr),
        ]) : const SizedBox(),
        SizedBox(height: checkoutController.isPartialPay ? Dimensions.paddingSizeSmall : 0),

        checkoutController.isPartialPay && !checkoutController.subscriptionOrder ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            'due_payment'.tr,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: !ResponsiveHelper.isDesktop(context) ? Theme.of(context).textTheme.bodyMedium!.color : Theme.of(context).primaryColor),
          ),
          PriceConverter.convertAnimationPrice(
            checkoutController.viewTotalPrice,
            textStyle: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: !ResponsiveHelper.isDesktop(context) ? Theme.of(context).textTheme.bodyMedium!.color : Theme.of(context).primaryColor),
          )
        ]) : const SizedBox(),

        ResponsiveHelper.isDesktop(context) ? Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Divider(thickness: 1, color: Theme.of(context).hintColor.withOpacity(0.5)),
        ) : const SizedBox(),

      ]),
    );
  }
}

