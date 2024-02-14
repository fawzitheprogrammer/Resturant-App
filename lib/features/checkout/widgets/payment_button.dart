import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentButton extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final int index;
  const PaymentButton({super.key, required this.index, required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(builder: (checkoutController) {
      bool selected = checkoutController.paymentMethodIndex == index;
      return Padding(
        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom:  Dimensions.paddingSizeSmall),
        child: InkWell(
          onTap: () => checkoutController.setPaymentMethod(index),
          child: Container(
            width: 200, padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              border: Border.all(color: selected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 1.5)
              // boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], blurRadius: 5, spreadRadius: 1)],
            ),
            child: Row(children: [
              Image.asset(
                icon, width: 20, height: 20,
                color: selected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Text(title, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: selected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor)),

            ]),

            /*child: ListTile(
              leading: Image.asset(
                icon, width: 20, height: 20,
                color: _selected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
              ),
              title: Text(
                title,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
              subtitle: Text(
                subtitle,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              trailing: _selected ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor) : null,
            ),*/
          ),
        ),
      );
    });
  }
}
