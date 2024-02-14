import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class OrderTypeWidget extends StatelessWidget {
  final String title;
  final String icon;
  final bool isSelected;
  final Function onTap;
  const OrderTypeWidget({super.key, required this.title, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(color: isSelected ? Theme.of(context).cardColor : Colors.transparent, width: 2),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 5, spreadRadius: 0, offset: const Offset(2, 5))] : [],
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Row(children: [
          Image.asset(
            icon, width: 24, height: 24,
            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text(
            title, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
            ),
          ),
        ]),
        /*child: ListTile(
            leading: Image.asset(
              icon, width: 30, height: 30,
              color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
            ),
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
            minLeadingWidth: 0,
            horizontalTitleGap: Dimensions.paddingSizeExtraSmall,
            title: Text(
              title,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
            subtitle: Text(
              subtitle,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
              maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
          ),*/
      ),
    );
  }
}
