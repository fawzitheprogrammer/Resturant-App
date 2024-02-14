import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/cuisine_card_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/features/cuisine/controllers/cuisine_controller.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WebCuisineViewWidget extends StatelessWidget {
  const WebCuisineViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CuisineController>(builder: (cuisineController) {
      return (cuisineController.cuisineModel != null && cuisineController.cuisineModel!.cuisines!.isEmpty) ? const SizedBox() : Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
        child: Container(
          height: 216, width: Dimensions.webMaxWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
          ),
          child: Stack(
            children: [
              Image.asset(Images.cuisineBg, height: 216, width: Dimensions.webMaxWidth, fit: BoxFit.cover, color: Theme.of(context).primaryColor),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeOverLarge),
                    child: Text('cuisine'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  ),

                  cuisineController.cuisineModel != null ? Row(children: [
                    Expanded(
                      child: SizedBox(
                        height: 120,
                        child: Padding(
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cuisineController.cuisineModel!.cuisines!.length > 7 ? 7 : cuisineController.cuisineModel!.cuisines!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 35),
                                  child: InkWell(
                                    hoverColor: Colors.transparent,
                                    onTap: () =>  Get.toNamed(RouteHelper.getCuisineRestaurantRoute(cuisineController.cuisineModel!.cuisines![index].id, cuisineController.cuisineModel!.cuisines![index].name)),
                                    child: CuisineCardWidget(
                                      image: '${Get.find<SplashController>().configModel!.baseUrls!.cuisineImageUrl}'
                                          '/${cuisineController.cuisineModel!.cuisines![index].image}',
                                      name: cuisineController.cuisineModel!.cuisines![index].name!,
                                    ),
                                  ),
                                );
                              }
                          ),
                        ),
                      ),
                    ),

                    ArrowIconButtonWidget(
                      onTap: () => Get.toNamed(RouteHelper.getCuisineRoute()),
                    ),

                    const SizedBox(width: 35),
                  ],
                  ): const WebCuisineShimmer()
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



class WebCuisineShimmer extends StatelessWidget {
  const WebCuisineShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        itemCount: 7,
        itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.only(right: 35),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeSmall), bottomRight: Radius.circular(Dimensions.paddingSizeSmall)),
              child: Shimmer(
                 enabled: true,
                duration: const Duration(seconds: 2),
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
            ),
          );
        },
      ),
    );
  }
}