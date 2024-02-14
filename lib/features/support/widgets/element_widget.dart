import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
class ElementWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  final Function() onTap;
  const ElementWidget({super.key, required this.image, required this.title, required this.subTitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return InkWell(
      onTap: onTap,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(image, height: isDesktop ? 70 : 45, width: isDesktop ? 70 : 45, fit: BoxFit.cover),
        SizedBox(height: isDesktop ? Dimensions.paddingSizeExtraLarge : 0),

        Text(title, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
        SizedBox(height: isDesktop ? Dimensions.paddingSizeExtraLarge : 0),

        Text(
          subTitle,
          style: robotoMedium.copyWith(fontSize: isDesktop ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor),
        ),

      ]),
    );
  }
}
