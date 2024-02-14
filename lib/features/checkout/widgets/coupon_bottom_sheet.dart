import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/coupon/widgets/coupon_card_widget.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponBottomSheet extends StatelessWidget {
  final CheckoutController checkoutController;
  final double price;
  final double discount;
  final double addOns;
  final double deliveryCharge;
  final double charge;
  final double total;
  const CouponBottomSheet({super.key, required this.checkoutController, required this.price, required this.discount, required this.addOns, required this.deliveryCharge, required this.total, required this.charge});

  @override
  Widget build(BuildContext context) {
    double totalPrice = total;
    return Container(
      width: Dimensions.webMaxWidth,
      height: context.height * 0.7 ,
      margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isMobile(context) ? const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge))
            : const BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: GetBuilder<CouponController>(
        builder: (couponController) {
          return Column(
            children: [

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                const SizedBox(width: 30),

                !ResponsiveHelper.isDesktop(context) ? Container(
                  height: 4, width: 35,
                  margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(10)),
                ) : const SizedBox(),

                IconButton(
                  onPressed: ()=> Get.back(),
                  icon: Icon(Icons.clear, color: Theme.of(context).disabledColor),
                ),
              ]),


              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  border: Border.all(color: Theme.of(context).textTheme.bodyMedium!.color!, width: 0.2),
                ),
                padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Row(children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: TextField(
                        controller: checkoutController.couponController,
                        style: robotoRegular.copyWith(height: ResponsiveHelper.isMobile(context) ? null : 2),
                        decoration: InputDecoration(
                            hintText: 'enter_promo_code'.tr,
                            hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                            isDense: true,
                            filled: true,
                            enabled: couponController.discount == 0,
                            fillColor: Theme.of(context).cardColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(Get.find<LocalizationController>().isLtr ? 10 : 0),
                                right: Radius.circular(Get.find<LocalizationController>().isLtr ? 0 : 10),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.local_offer_outlined, color: Theme.of(context).primaryColor)
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      String couponCode = checkoutController.couponController.text.trim();
                      if(couponController.discount! < 1 && !couponController.freeDelivery) {
                        if(couponCode.isNotEmpty && !couponController.isLoading) {
                          couponController.applyCoupon(couponCode, (price-discount)+addOns, deliveryCharge,
                              charge, totalPrice, Get.find<RestaurantController>().restaurant!.id).then((discount) {
                            if (discount! > 0) {
                              showCustomSnackBar(
                                '${'you_got_discount_of'.tr} ${PriceConverter.convertPrice(discount)}',
                                isError: false, showToaster: true,
                              );
                              if(checkoutController.isPartialPay || checkoutController.paymentMethodIndex == 1) {
                                totalPrice = totalPrice - discount;
                                checkoutController.checkBalanceStatus(totalPrice);
                              }
                            }
                          });
                        } else if(couponCode.isEmpty) {
                          showCustomSnackBar('enter_a_coupon_code'.tr);
                        }
                      } else {
                        totalPrice = totalPrice + couponController.discount!;
                        couponController.removeCouponData(true);
                        checkoutController.couponController.text = '';
                        if(checkoutController.isPartialPay || checkoutController.paymentMethodIndex == 1){
                          checkoutController.checkBalanceStatus(totalPrice);
                        }
                      }
                    },
                    child: Container(
                      height: 45, width: (couponController.discount! <= 0 && !couponController.freeDelivery) ? 100 : 50,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: (couponController.discount! <= 0 && !couponController.freeDelivery) ? Theme.of(context).primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: (couponController.discount! <= 0 && !couponController.freeDelivery) ? !couponController.isLoading ? Text(
                        'apply'.tr,
                        style: robotoMedium.copyWith(color: Colors.white),
                      ) : const SizedBox(
                        height: 30, width: 30,
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                      )
                          : Icon(Icons.clear, color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                ]),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                  child: Column(children: [

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('available_promo'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      const SizedBox(),
                    ]),

                    couponController.couponList != null && couponController.couponList!.isNotEmpty ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                        mainAxisSpacing: Dimensions.paddingSizeSmall, crossAxisSpacing: Dimensions.paddingSizeSmall,
                        childAspectRatio: ResponsiveHelper.isMobile(context) ? 3 : 2.5,
                      ),
                      itemCount: couponController.couponList!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if(couponController.couponList![index].code != null) {
                              checkoutController.couponController.text = couponController.couponList![index].code.toString();
                            }
                            if(checkoutController.couponController.text.isNotEmpty){
                              if(couponController.discount! < 1 && !couponController.freeDelivery) {
                                if(checkoutController.couponController.text.isNotEmpty && !couponController.isLoading) {
                                  couponController.applyCoupon(checkoutController.couponController.text, (price-discount)+addOns, deliveryCharge,
                                    charge, totalPrice, Get.find<RestaurantController>().restaurant!.id, hideBottomSheet: true).then((discount) {

                                    checkoutController.couponController.text = '${checkoutController.couponController.text}(${couponController.freeDelivery ? 'free_delivery'.tr : PriceConverter.convertPrice(couponController.discount)})';
                                    if (discount! > 0) {
                                      // orderController.couponController.text = 'coupon_applied'.tr;
                                      showCustomSnackBar(
                                        '${'you_got_discount_of'.tr} ${PriceConverter.convertPrice(discount)}',
                                        isError: false,
                                      );
                                      if(checkoutController.isPartialPay || checkoutController.paymentMethodIndex == 1) {
                                        // totalPrice = totalPrice - discount;
                                        checkoutController.checkBalanceStatus(totalPrice, discount: discount);
                                      }
                                    } else{
                                      if(checkoutController.isPartialPay || checkoutController.paymentMethodIndex == 1) {
                                        checkoutController.checkBalanceStatus(totalPrice);
                                      }
                                    }
                                  });
                                } else if(checkoutController.couponController.text.isEmpty) {
                                  showCustomSnackBar('enter_a_coupon_code'.tr);
                                }
                              } else {
                                totalPrice = totalPrice + couponController.discount!;
                                couponController.removeCouponData(true);
                                checkoutController.couponController.text = '';
                                if(checkoutController.isPartialPay || checkoutController.paymentMethodIndex == 1){
                                  checkoutController.checkBalanceStatus(totalPrice);
                                }
                              }
                            }
                          },
                          child: CouponCardWidget(couponController: couponController, index: index),
                        );
                      },
                    ): Column(
                      children: [
                        Image.asset(Images.noCoupon, height: 70),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Text('no_promo_available'.tr, style: robotoMedium),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Text(
                          '${'please_add_manually_or_collect_promo_from'.tr} ${'your_business_name'.tr}',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                        ),
                        const SizedBox(height: 50),

                      ],
                    ),

                  ]),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
