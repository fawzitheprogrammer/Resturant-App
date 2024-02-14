import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DeliveryOptionButton extends StatelessWidget {
  final String value;
  final String title;
  final double? charge;
  final bool? isFree;
  final double total;
  const DeliveryOptionButton({super.key, required this.value, required this.title, required this.charge, required this.isFree, required this.total});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (checkoutController) {
        bool select = checkoutController.orderType == value;
        return InkWell(
          onTap: () {
            checkoutController.setOrderType(value);
            checkoutController.setInstruction(-1);

            if(checkoutController.orderType == 'take_away') {
              checkoutController.addTips(0);
              if(checkoutController.isPartialPay || checkoutController.paymentMethodIndex == 1) {
                double tips = 0;
                try{
                  tips = double.parse(checkoutController.tipController.text);
                } catch(_) {}
                checkoutController.checkBalanceStatus(total, discount: charge! + tips);
              }
            }else{
              checkoutController.updateTips(
                Get.find<AuthController>().getDmTipIndex().isNotEmpty ? int.parse(Get.find<AuthController>().getDmTipIndex()) : 0, notify: false,
              );

              if(checkoutController.isPartialPay){
                checkoutController.changePartialPayment();
              } else {
                checkoutController.setPaymentMethod(-1);
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: select ? Theme.of(context).cardColor : Colors.transparent,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 2),
            child: Row(
              children: [
                Radio(
                  value: value,
                  groupValue: checkoutController.orderType,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (String? value) {
                    checkoutController.setOrderType(value!);
                  },
                  activeColor: Theme.of(context).primaryColor,
                  visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Text(title, style: robotoMedium.copyWith(color: select ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium!.color)),
                const SizedBox(width: 5),

                // Text(
                //   '(${(value == 'take_away' || isFree!) ? 'free'.tr : charge != -1 ? PriceConverter.convertPrice(charge) : 'calculating'.tr})',
                //   style: robotoMedium,
                // ),

              ],
            ),
          ),
        );
      },
    );
  }
}
