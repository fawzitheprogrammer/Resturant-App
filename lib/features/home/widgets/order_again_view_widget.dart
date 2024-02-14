import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/restaurants_card_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderAgainViewWidget extends StatelessWidget {
  const OrderAgainViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      return (restController.orderAgainRestaurantList != null && restController.orderAgainRestaurantList!.isNotEmpty) ? Padding(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge),
        child: SizedBox(
          height: ResponsiveHelper.isDesktop(context) ? 236 : 230,
          width: Dimensions.webMaxWidth,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: ResponsiveHelper.isMobile(context) ? CrossAxisAlignment.start : CrossAxisAlignment.center, children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                        child: Text('order_again'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      ),

                      Text('${'recently_you_ordered_from'.tr} ${restController.orderAgainRestaurantList!.length} ${'restaurants'.tr}',
                          style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
                    ],
                  ),
                ),

                ArrowIconButtonWidget(
                  onTap: () => Get.toNamed(RouteHelper.getAllRestaurantRoute('order_again')),
                ),
              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            SizedBox(
              height: ResponsiveHelper.isDesktop(context) ? 155 : 150,
              child: ListView.builder(
                itemCount: restController.orderAgainRestaurantList!.length,
                padding: EdgeInsets.only(right: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                    child: RestaurantsCardWidget(
                      isNewOnStackFood: false,
                      restaurant: restController.orderAgainRestaurantList![index],
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
      ) : const SizedBox();
    });
  }
}