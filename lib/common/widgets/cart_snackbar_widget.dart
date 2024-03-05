import 'package:swift_tech_resto/helper/responsive_helper.dart';
import 'package:swift_tech_resto/helper/route_helper.dart';
import 'package:swift_tech_resto/util/dimensions.dart';
import 'package:swift_tech_resto/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCartSnackBarWidget() {
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    dismissDirection: DismissDirection.horizontal,
    margin: ResponsiveHelper.isDesktop(Get.context)
        ? EdgeInsets.only(
            right: Get.context!.width * 0.7,
            left: Dimensions.paddingSizeSmall,
            bottom: Dimensions.paddingSizeSmall,
          )
        : const EdgeInsets.all(Dimensions.paddingSizeSmall),
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.green,
    action: SnackBarAction(
        label: 'view_cart'.tr,
        textColor: Colors.white,
        onPressed: () {
          Get.toNamed(RouteHelper.getCartRoute());
        }),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
    content: Text(
      'item_added_to_cart'.tr,
      style: robotoMedium.copyWith(color: Colors.white),
    ),
  ));
}
