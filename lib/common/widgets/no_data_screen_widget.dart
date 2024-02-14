import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoDataScreen extends StatelessWidget {
  final bool isCart;
  final String? title;
  final bool fromAddress;
  final bool isRestaurant;
  const NoDataScreen({super.key, required this.title, this.isCart = false, this.fromAddress = false, this.isRestaurant = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Column(mainAxisAlignment:  fromAddress ? MainAxisAlignment.start : MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [

        fromAddress ? const SizedBox(height:100) : const SizedBox(),

        Center(
          child: Image.asset(
            fromAddress ? Images.address : isCart ? Images.emptyCart : isRestaurant ? Images.emptyRestaurant : Images.emptyFood,
            width: MediaQuery.of(context).size.height*0.22, height: MediaQuery.of(context).size.height*0.22,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height*0.03),

        Text(
          isCart ? 'cart_is_empty'.tr : title!,
          style: robotoMedium.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: fromAddress ? Theme.of(context).textTheme.bodyMedium!.color : Theme.of(context).disabledColor),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: MediaQuery.of(context).size.height*0.03),

        fromAddress ? Text(
          isCart ? '' : 'please_add_your_address_for_your_better_experience'.tr,
          style: robotoMedium.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: Theme.of(context).disabledColor),
          textAlign: TextAlign.center,
        ) : Text(
          'sorry_no_data_found_related_to_your_search'.tr,
          style: robotoRegular.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: Theme.of(context).disabledColor),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: MediaQuery.of(context).size.height*0.05),


        fromAddress ? InkWell(
          onTap: () => Get.toNamed(RouteHelper.getAddAddressRoute(false, 0)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color: Theme.of(context).primaryColor,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle_outline_sharp, size: 18.0, color: Theme.of(context).cardColor),
                Text('add_address'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor)),
              ],
            ),
          ),
        ) : const SizedBox(),


      ]),
    );
  }
}
