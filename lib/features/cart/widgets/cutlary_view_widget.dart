import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
class CutleryViewWidget extends StatelessWidget {
  final RestaurantController restaurantController;
  final CartController cartController;
  const CutleryViewWidget({super.key, required this.restaurantController, required this.cartController});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return (restaurantController.restaurant != null && restaurantController.restaurant!.cutlery != null && restaurantController.restaurant!.cutlery!) ? Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, spreadRadius: 1, offset: const Offset(1, 2))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [

        Icon(Icons.flatware, size: isDesktop ? 30 : 25, color: Theme.of(context).primaryColor),
        const SizedBox(width: Dimensions.paddingSizeDefault),

        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('add_cutlery'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text('do_not_have_cutlery'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
          ]),
        ),

        Transform.scale(
          scale: 0.7,
          child: CupertinoSwitch(
            value: cartController.addCutlery,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (bool? value) {
              cartController.updateCutlery();
            },
            trackColor: Theme.of(context).primaryColor.withOpacity(0.2),
          ),
        )

      ]),
    ) : const SizedBox();
  }
}
