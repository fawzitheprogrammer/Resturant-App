import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Function? onTap;
  const TitleWidget({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(title, style: robotoMedium.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeOverLarge : Dimensions.fontSizeLarge)),
      const Expanded(child: SizedBox()),

      (onTap != null && !ResponsiveHelper.isDesktop(context)) ? InkWell(
        onTap: onTap as void Function()?,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
          child: Text(
            'view_all'.tr,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
          ),
        ),
      ) : const SizedBox(),

      (onTap != null && ResponsiveHelper.isDesktop(context)) ? InkWell(
        onTap: onTap as void Function()?,
        child: Row(children: [
          Text(
            'view_all'.tr,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle, color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), spreadRadius: 1, blurRadius: 5)],
            ),
            padding: const EdgeInsets.all(5),
            child: Icon(Icons.arrow_forward_ios_sharp, size: 14, color: Theme.of(context).primaryColor),
          )
        ]),
      ) : const SizedBox(),

    ]);
  }
}
