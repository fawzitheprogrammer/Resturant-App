import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class PaymentButtonNew extends StatelessWidget {
  final String icon;
  final String title;
  final bool isSelected;
  final Function onTap;
  const PaymentButtonNew({super.key, required this.isSelected, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withOpacity(0.5)),
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Row(children: [
            Image.asset(icon, width: 20, height: 20),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
              child: Text(
                title,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
            ),

            isSelected ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              padding: const EdgeInsets.all(2),
              child: const Icon(Icons.check, color: Colors.white, size: 18),
            ) : const SizedBox(),
          ]),

        ),
      ),
    );
  }
}
