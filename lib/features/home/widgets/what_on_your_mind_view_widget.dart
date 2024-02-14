import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WhatOnYourMindViewWidget extends StatelessWidget {
  const WhatOnYourMindViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.only(
            top: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeOverLarge,
            left: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeExtraSmall : 0,
            right: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeExtraSmall,
            bottom: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeOverLarge,
          ),
          child: ResponsiveHelper.isDesktop(context) ? Text('what_on_your_mind'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600)) :
          Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeDefault),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('what_on_your_mind'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600)),
              ArrowIconButtonWidget(onTap: () => Get.toNamed(RouteHelper.getCategoryRoute())),
            ],
            ),
          ),
        ),

        SizedBox(
          height: ResponsiveHelper.isMobile(context) ? 120 : 170,
          child: categoryController.categoryList != null ? ListView.builder(
            physics: ResponsiveHelper.isMobile(context) ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
            itemCount: categoryController.categoryList!.length > 10 ? 11 : categoryController.categoryList!.length,
            itemBuilder: (context, index) {

              if(index == 10) {
                return ResponsiveHelper.isDesktop(context) ? Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeSmall),
                  child: Container(
                    width: 70,
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall, right: Dimensions.paddingSizeExtraSmall, top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        hoverColor: Colors.transparent,
                        onTap: () => Get.toNamed(RouteHelper.getCategoryRoute()),
                        child: Container(
                          height: 40, width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).cardColor,
                            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                          ),
                          child: Icon(Icons.arrow_forward, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                ): const SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall),
                child: Container(
                  width: ResponsiveHelper.isMobile(context) ? 70 : 100,
                  height: ResponsiveHelper.isMobile(context) ? 70 : 100,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall)
                  ),
                  child: CustomInkWellWidget(
                    onTap: () => Get.toNamed(RouteHelper.getCategoryProductRoute(
                      categoryController.categoryList![index].id, categoryController.categoryList![index].name!,
                    )),
                    radius: Dimensions.radiusSmall,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: Column(children: [

                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).cardColor,
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, spreadRadius: 1)]
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: CustomImageWidget(
                              image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].image}',
                              height: ResponsiveHelper.isMobile(context) ? 70 : 100, width: ResponsiveHelper.isMobile(context) ? 70 : 100, fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge),

                        Expanded(child: Text(
                          categoryController.categoryList![index].name!,
                          style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            // color:Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                          maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                        )),

                      ]),
                    ),
                  ),
                ),
              );
            },
          ) : WebWhatOnYourMindViewShimmer(categoryController: categoryController),
        ),

        const SizedBox(height: Dimensions.paddingSizeLarge),

      ]);
    });
  }
}


class WebWhatOnYourMindViewShimmer extends StatelessWidget {
  final CategoryController categoryController;
  const WebWhatOnYourMindViewShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.isMobile(context) ? 120 : 170,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeSmall),
            child: Container(
              width: ResponsiveHelper.isMobile(context) ? 70 : 108,
              height: ResponsiveHelper.isMobile(context) ? 70 : 100,
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              margin: EdgeInsets.only(top: ResponsiveHelper.isMobile(context) ? 0 : Dimensions.paddingSizeSmall),
              child: Shimmer(
                duration: const Duration(seconds: 2),
                enabled: categoryController.categoryList == null,
                child: Column(children: [

                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.grey[300]),
                    height: ResponsiveHelper.isMobile(context) ? 70 : 80, width: 70,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(height: ResponsiveHelper.isMobile(context) ? 10 : 15, width: 150, color: Colors.grey[300]),

                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}


