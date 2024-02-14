import 'package:stackfood_multivendor/features/business/controllers/business_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class BaseCardWidget extends StatelessWidget {
  final BusinessController businessController;
  final String title;
  final int index;
  final Function onTap;
  const BaseCardWidget({super.key, required this.businessController, required this.title, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Stack(clipBehavior: Clip.none, children: [

        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              color: businessController.businessIndex == index ? Theme.of(context).primaryColor.withOpacity(0.1) : Theme.of(context).cardColor,
              border: businessController.businessIndex == index ? Border.all(color: Theme.of(context).primaryColor, width: 0.5) : null,
              boxShadow: businessController.businessIndex == index ? null : [BoxShadow(color: Colors.grey[200]!, offset: const Offset(5, 5), blurRadius: 10)]
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
          child: Center(child: Text(title, style: robotoMedium.copyWith(color: businessController.businessIndex == index ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeDefault))),
        ),

        businessController.businessIndex == index ? Positioned(
          top: -10, right: -10,
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              shape: BoxShape.circle, color: Theme.of(context).primaryColor,
            ),
            child: Icon(Icons.check, size: 14, color: Theme.of(context).cardColor),
          ),
        ) : const SizedBox()
      ]),
    );
  }
}