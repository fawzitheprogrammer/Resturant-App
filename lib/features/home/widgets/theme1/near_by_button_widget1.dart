import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NearByButtonWidget1 extends StatelessWidget {
  const NearByButtonWidget1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.webMaxWidth,
      height: 90,
      margin: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeDefault),
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: const [BoxShadow(
          color: Colors.black12,
          blurRadius: 5, spreadRadius: 1,
        )],
      ),
      child: Row(children: [

        Image.asset(Images.nearRestaurant, height: 40, width: 40, fit: BoxFit.cover),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(
          child: Text(
            'find_nearby_restaurant_near_you'.tr, textAlign: TextAlign.start,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),

        CustomButtonWidget(buttonText: 'see_location'.tr, width: 120, height: 40, onPressed: ()=> Get.toNamed(RouteHelper.getMapViewRoute())),

      ]),
    );
  }
}
