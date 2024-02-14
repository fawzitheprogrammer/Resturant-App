import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class SlotWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function onTap;
  final bool fromCustomDate;
  const SlotWidget({super.key, required this.title, required this.isSelected, required this.onTap, this.fromCustomDate = false});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Padding(
      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: fromCustomDate ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeExtraSmall),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : isDesktop || fromCustomDate ? Theme.of(context).disabledColor.withOpacity(0.2) : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            boxShadow: isDesktop || fromCustomDate ? [] : const [BoxShadow(color: Colors.black12, spreadRadius: 0.5, blurRadius: 0.5)],
          ),
          child: Text(
            title,
            style: robotoRegular.copyWith(
              color: isSelected ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: isDesktop ? 10 : fromCustomDate ? Dimensions.fontSizeSmall : Dimensions.fontSizeExtraSmall,
            ),
          ),
        ),
      ),
    );
  }
}
