import 'package:stackfood_multivendor/common/widgets/rating_bar_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductShimmer extends StatelessWidget {
  final bool isEnabled;
  final bool isRestaurant;
  final bool hasDivider;
  const ProductShimmer({super.key, required this.isEnabled, required this.hasDivider, this.isRestaurant = false});

  @override
  Widget build(BuildContext context) {
    bool desktop = ResponsiveHelper.isDesktop(context);

    return Container(
      padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.all(Dimensions.paddingSizeSmall) : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).cardColor : null,
        boxShadow: ResponsiveHelper.isDesktop(context) ? [BoxShadow(
          color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5,
        )] : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: desktop ? 0 : Dimensions.paddingSizeExtraSmall),
              child: Row(children: [

                Container(
                  height: desktop ? 120 : 65, width: desktop ? 120 : 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                    Container(height: desktop ? 20 : 10, width: double.maxFinite, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Container(
                      height: desktop ? 15 : 10, width: double.maxFinite, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                      margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                    ),
                    SizedBox(height: isRestaurant ? Dimensions.paddingSizeSmall : 0),

                    !isRestaurant ? RatingBarWidget(rating: 0, size: desktop ? 15 : 12, ratingCount: 0) : const SizedBox(),
                    isRestaurant ? RatingBarWidget(
                      rating: 0, size: desktop ? 15 : 12,
                      ratingCount: 0,
                    ) : Row(children: [
                      Container(height: desktop ? 20 : 15, width: 30, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Container(height: desktop ? 15 : 10, width: 20, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
                    ]),

                  ]),
                ),

                Column(mainAxisAlignment: isRestaurant ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween, children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: desktop ? Dimensions.paddingSizeSmall : 0),
                    child: Icon(
                      Icons.favorite_border,  size: desktop ? 30 : 25,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),

                  !isRestaurant ? Padding(
                    padding: EdgeInsets.symmetric(vertical: desktop ? Dimensions.paddingSizeSmall : 0),
                    child: Icon(Icons.add, size: desktop ? 30 : 25),
                  ) : const SizedBox(),
                ]),

              ]),
            ),
          ),
          desktop ? const SizedBox() : Padding(
            padding: EdgeInsets.only(left: desktop ? 130 : 90),
            child: Divider(color: hasDivider ? Theme.of(context).disabledColor : Colors.transparent),
          ),
        ],
      ),
    );
  }
}
