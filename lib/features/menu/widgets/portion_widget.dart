import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortionWidget extends StatelessWidget {
  final String icon;
  final String title;
  final bool hideDivider;
  final String route;
  final String? suffix;
  const PortionWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.route,
      this.hideDivider = false,
      this.suffix});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(route),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeDefault,
          horizontal: Dimensions.paddingSizeDefault,
        ),
        margin:
            const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.15),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(
            Dimensions.radiusDefault,
          ),
        ),
        child: Column(children: [
          Row(children: [
            Image.asset(
              icon,
              height: 16,
              width: 16,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
              child: Text(
                title,
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault),
              ),
            ),
            suffix != null
                ? Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeExtraSmall,
                        horizontal: Dimensions.paddingSizeSmall),
                    child: Text(suffix!,
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).cardColor)),
                  )
                : const SizedBox(),
          ]),
          //hideDivider ? const SizedBox() : const Divider()
        ]),
      ),
    );
  }
}
