import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CheckoutButtonWidget extends StatelessWidget {
  final CartController cartController;
  final List<bool> availableList;
  const CheckoutButtonWidget({super.key, required this.cartController, required this.availableList});

  @override
  Widget build(BuildContext context) {
    double percentage = 0;
    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Container(
      width: Dimensions.webMaxWidth,
      padding:  const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: isDesktop ? null : BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.2), blurRadius: 10)]
      ),
      child: SafeArea(
        child: GetBuilder<RestaurantController>(builder: (restaurantController) {
          if(Get.find<RestaurantController>().restaurant != null && Get.find<RestaurantController>().restaurant!.freeDelivery != null && !Get.find<RestaurantController>().restaurant!.freeDelivery! &&  Get.find<SplashController>().configModel!.freeDeliveryOver != null){
            percentage = cartController.subTotal/Get.find<SplashController>().configModel!.freeDeliveryOver!;
          }
          return Column(mainAxisSize: MainAxisSize.min, children: [
            (restaurantController.restaurant != null && restaurantController.restaurant!.freeDelivery != null && !restaurantController.restaurant!.freeDelivery!
            && Get.find<SplashController>().configModel!.freeDeliveryOver != null && percentage < 1)
            ? Padding(
              padding: EdgeInsets.only(bottom: isDesktop ? Dimensions.paddingSizeLarge : 0),
              child: Column(children: [
                Row(children: [
                  Image.asset(Images.percentTag, height: 20, width: 20),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  PriceConverter.convertAnimationPrice(
                    Get.find<SplashController>().configModel!.freeDeliveryOver! - cartController.subTotal,
                    textStyle: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Text('more_for_free_delivery'.tr, style: robotoMedium.copyWith(color: Theme.of(context).disabledColor)),
                ]),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                LinearProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  value: percentage,
                ),
              ]),
            ) : const SizedBox(),


            !isDesktop ? Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('subtotal'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
                  PriceConverter.convertAnimationPrice(cartController.subTotal, textStyle: robotoRegular.copyWith(color: Theme.of(context).primaryColor)),
                ],
              ),
            ) : const SizedBox(),

            GetBuilder<CartController>(
              builder: (cartController) {
                return CustomButtonWidget(
                  radius: 10,
                  buttonText: 'proceed_to_checkout'.tr,
                  onPressed: cartController.isLoading ? null : () {
                    _processToCheckoutButtonPressed(restaurantController);
                  },
                );
              }
            ),
            SizedBox(height: isDesktop ? Dimensions.paddingSizeExtraLarge : 0),
          ]);
        }),
      ),
    );
  }

  void _processToCheckoutButtonPressed(RestaurantController restaurantController) {
    if(!cartController.cartList.first.product!.scheduleOrder! && cartController.availableList.contains(false)) {
      showCustomSnackBar('one_or_more_product_unavailable'.tr);
    } else if(restaurantController.restaurant!.freeDelivery == null || restaurantController.restaurant!.cutlery == null) {
      showCustomSnackBar('restaurant_is_unavailable'.tr);
    }
    else {
      Get.find<CouponController>().removeCouponData(false);
      Get.toNamed(RouteHelper.getCheckoutRoute('cart'));
    }
  }

}