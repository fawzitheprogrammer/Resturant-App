import 'package:stackfood_multivendor/features/business/controllers/business_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentCartWidget extends StatelessWidget {
  final String title;
  final int index;
  final Function onTap;
  const PaymentCartWidget({super.key, required this.title, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BusinessController>(
        builder: (businessController) {
          return Stack( clipBehavior: Clip.none, children: [
            InkWell(
              onTap: onTap as void Function()?,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  border: businessController.paymentIndex == index ? Border.all(color: Theme.of(context).primaryColor, width: 1) : null,
                  boxShadow: businessController.paymentIndex != index ? [BoxShadow(color: Colors.grey[300]!, blurRadius: 10)] : null,
                  color: businessController.paymentIndex == index ? Theme.of(context).primaryColor.withOpacity(0.05) : Theme.of(context).cardColor,
                ),
                alignment: Alignment.center,
                width: context.width,
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                child: Text(title, style: robotoBold.copyWith(color: businessController.paymentIndex == index ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge!.color)),
              ),
            ),

            businessController.paymentIndex == index ? Positioned(
              top: -8, right: -8,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                child: Icon(Icons.check, size: 18, color: Theme.of(context).cardColor),
              ),
            ) : const SizedBox(),
          ],
          );
        }
    );
  }
}
