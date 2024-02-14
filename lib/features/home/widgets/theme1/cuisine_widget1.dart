import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/cuisine/controllers/cuisine_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
class CuisinesWidget1 extends StatelessWidget {
  const CuisinesWidget1({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CuisineController>(
      builder: (cuisineController) {
        return (cuisineController.cuisineModel != null && cuisineController.cuisineModel!.cuisines!.isEmpty) ? const SizedBox() : Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TitleWidget(title: 'cuisines'.tr, onTap: () => Get.toNamed(RouteHelper.getCuisineRoute())),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: cuisineController.cuisineModel != null ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: Dimensions.paddingSizeSmall,
                  crossAxisSpacing: Dimensions.paddingSizeLarge,
                  childAspectRatio: 0.8,
                ),
                shrinkWrap: true,
                itemCount: ResponsiveHelper.isMobile(context) ? cuisineController.cuisineModel!.cuisines!.length > 8 ? 8 : cuisineController.cuisineModel!.cuisines!.length : ResponsiveHelper.isTab(context) ? 10 : 0,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
              return InkWell(
                onTap: (){
                  Get.toNamed(RouteHelper.getCuisineRestaurantRoute(cuisineController.cuisineModel!.cuisines![index].id, cuisineController.cuisineModel!.cuisines![index].name));
                },
                child: Column(children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: CustomImageWidget(
                        fit: BoxFit.cover,
                        image: '${Get.find<SplashController>().configModel!.baseUrls!.cuisineImageUrl}/${cuisineController.cuisineModel!.cuisines![index].image}',
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(
                    cuisineController.cuisineModel!.cuisines![index].name!,
                    style: robotoMedium.copyWith(fontSize: 11),
                    maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                  ),
                ]),
              );
            }) : CuisineShimmer(cuisineController: cuisineController),
          )
        ]);
      }
    );
  }
}

class CuisineShimmer extends StatelessWidget {
  final CuisineController cuisineController;
  const CuisineShimmer({super.key, required this.cuisineController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: Dimensions.paddingSizeSmall,
            crossAxisSpacing: Dimensions.paddingSizeLarge,
            childAspectRatio: 0.8,
          ),
          shrinkWrap: true,
          itemCount: ResponsiveHelper.isMobile(context) ?  8 : 10,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return Shimmer(
              duration: const Duration(seconds: 2),
              enabled: cuisineController.cuisineModel == null,
              child: Column(children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        )
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    )
                ),
              ]),
            );
          }),
    );
  }
}
