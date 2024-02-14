import 'package:stackfood_multivendor/features/auth/controllers/deliveryman_registration_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassViewWidget extends StatelessWidget {
  const PassViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliverymanRegistrationController>(
      builder: (deliverymanRegiController) {
        return Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
          child: Wrap(children: [

            view('8_or_more_character'.tr, deliverymanRegiController.lengthCheck),

            view('1_number'.tr, deliverymanRegiController.numberCheck),

            view('1_upper_case'.tr, deliverymanRegiController.uppercaseCheck),

            view('1_lower_case'.tr, deliverymanRegiController.lowercaseCheck),

            view('1_special_character'.tr, deliverymanRegiController.spatialCheck),

          ]),
        );
      }
    );
  }

  Widget view(String title, bool done){
    return Padding(
      padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(done ? Icons.check : Icons.clear, color: done ? Colors.green : Colors.red, size: 12),
        Text(title, style: robotoRegular.copyWith(color: done ? Colors.green : Colors.red, fontSize: 12))
      ]),
    );
  }
}
