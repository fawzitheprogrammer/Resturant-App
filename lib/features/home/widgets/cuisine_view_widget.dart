import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/cuisine_card_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/features/cuisine/controllers/cuisine_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CuisineViewWidget extends StatelessWidget {
  const CuisineViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CuisineController>(builder: (cuisineController) {
        return (cuisineController.cuisineModel != null && cuisineController.cuisineModel!.cuisines!.isEmpty) ? const SizedBox() : Padding(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isMobile(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge),
          child: Container(
            width: Dimensions.webMaxWidth,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.all(Radius.circular(ResponsiveHelper.isMobile(context) ? 0 : Dimensions.radiusSmall)),
            ),
            child: Stack(
              children: [
                Image.asset(Images.cuisineBg, width: Dimensions.webMaxWidth, fit: BoxFit.contain, color: Theme.of(context).primaryColor),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('cuisine'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                        ArrowIconButtonWidget(onTap: () => Get.toNamed(RouteHelper.getCuisineRoute())),
                      ],
                      ),
                    ),

                    cuisineController.cuisineModel != null ? GridView.builder(
                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cuisineController.cuisineModel!.cuisines!.length > 7  ? 8 : cuisineController.cuisineModel!.cuisines!.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: ResponsiveHelper.isMobile(context) ? 4 : ResponsiveHelper.isDesktop(context) ? 7 : 6,
                        mainAxisSpacing: Dimensions.paddingSizeDefault,
                        crossAxisSpacing: Dimensions.paddingSizeDefault,
                        childAspectRatio: 1
                      ),
                      itemBuilder: (context, index) {
                        return CustomInkWellWidget(
                          onTap: () =>  Get.toNamed(RouteHelper.getCuisineRestaurantRoute(cuisineController.cuisineModel!.cuisines![index].id, cuisineController.cuisineModel!.cuisines![index].name)),
                          radius: Dimensions.radiusDefault,
                          child: CuisineCardWidget(
                            image: '${Get.find<SplashController>().configModel!.baseUrls!.cuisineImageUrl}'
                                '/${cuisineController.cuisineModel!.cuisines![index].image}',
                            name: cuisineController.cuisineModel!.cuisines![index].name!,
                          ),
                        );

                      },
                    )  : const CuisineShimmer()
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}



class CuisineShimmer extends StatelessWidget {
  const CuisineShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, mainAxisSpacing: Dimensions.paddingSizeDefault, crossAxisSpacing: Dimensions.paddingSizeDefault,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeSmall), bottomRight: Radius.circular(Dimensions.paddingSizeSmall)),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: Stack(
              children: [
                Positioned(bottom: -55,left: 0,right: 0,
                  child: Transform.rotate(
                    angle: 40,
                    child: Container(
                      height: 120, width: 120,
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(decoration: BoxDecoration( color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300], borderRadius: BorderRadius.circular(50)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        height: 100, width: 100,
                        color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                      )
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    height: 30, width: 120,
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeSmall), bottomRight: Radius.circular(Dimensions.paddingSizeSmall)),
                    ),
                  ),
                )
              ],
            ),
          ),
        );

      },
    );
  }
}



