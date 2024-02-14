import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/coupon_bottom_sheet.dart';
import 'package:stackfood_multivendor/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CouponSection extends StatelessWidget {
  final CheckoutController checkoutController;
  final double price;
  final double discount;
  final double addOns;
  final double deliveryCharge;
  final double charge;
  final double total;
  const CouponSection({super.key, required this.checkoutController, required this.price, required this.discount, required this.addOns, required this.deliveryCharge, required this.total, required this.charge});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return GetBuilder<CouponController>(
      builder: (couponController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, spreadRadius: 1, offset: const Offset(1, 2))],
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          margin: EdgeInsets.symmetric(horizontal: isDesktop ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeDefault),
          child: (couponController.discount! <= 0 && !couponController.freeDelivery) ? Row(children: [
            Expanded(
              child: Row(children: [
                Image.asset(Images.couponIcon1, height: 20, width: 20),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text('add_coupon'.tr, style: robotoRegular),
              ]),
            ),

            InkWell(
              onTap: () {
                if(ResponsiveHelper.isDesktop(context)){
                  Get.dialog(Dialog(child: CouponBottomSheet(checkoutController: checkoutController, price: price, discount: discount, addOns: addOns, deliveryCharge: deliveryCharge, charge: charge, total: total))).then((value) {
                    if(value != null) {
                      checkoutController.couponController.text = value.toString();
                    }
                  });
                }else{
                  Get.bottomSheet(
                    CouponBottomSheet(checkoutController: checkoutController, price: price, discount: discount, addOns: addOns, deliveryCharge: deliveryCharge, charge: charge, total: total),
                    backgroundColor: Colors.transparent, isScrollControlled: true,
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(children: [
                  Text('add'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  const Icon(Icons.add, size: 20),
                ]),
              ),
            ),
          ]) : Column(children: [
            Row(children: [
              const Icon(Icons.check_circle_rounded, size: 16, color: Colors.green),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Text('${'coupon_applied'.tr}!', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                border: Border.all(color: Theme.of(context).disabledColor, width: 0.6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
              child: Row(
                children: [
                  Expanded(
                    child: Row(children: [
                      Image.asset(Images.couponIcon1, height: 20, width: 20),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Text(checkoutController.couponController.text, style: robotoRegular),
                    ]),
                  ),

                  InkWell(
                  onTap: () {
                    couponController.removeCouponData(true);
                    checkoutController.couponController.text = '';
                    if(checkoutController.isPartialPay || checkoutController.paymentMethodIndex == 1){
                      checkoutController.checkBalanceStatus((total + charge));
                    }
                  },
                    child: SizedBox(height: 50, width: 50, child: Icon(Icons.clear, color: Theme.of(context).colorScheme.error)),
                  )
                ],
              ),
            )
          ]),
        );
      },
    );
  }
}
