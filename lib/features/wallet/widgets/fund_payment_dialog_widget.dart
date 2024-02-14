import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FundPaymentDialogWidget extends StatelessWidget {
  final bool isSubscription;
  const FundPaymentDialogWidget({super.key, required this.isSubscription});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Image.asset(Images.warning, width: 70, height: 70),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Text(
                isSubscription ? 'do_you_want_to_cancel_this_payment'.tr : 'do_you_want_to_cancel_this_add_fund'.tr, textAlign: TextAlign.center,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.red),
              ),
            ),

            TextButton(
              onPressed: () {
                if(Get.isDialogOpen!){
                  Get.back();
                }
                Get.back();
                // Get.offAllNamed(RouteHelper.getInitialRoute());
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), minimumSize: const Size(Dimensions.webMaxWidth, 40), padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
              ),
              child: Text(isSubscription ? 'cancel_payment'.tr : 'cancel_add_fund'.tr, textAlign: TextAlign.center, style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
            ),
          ]),
        ),
      ),
    );
  }
}
