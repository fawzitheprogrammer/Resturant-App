import 'package:carousel_slider/carousel_slider.dart';
import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/item_card_widget.dart';
import 'package:stackfood_multivendor/features/product/controllers/product_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularFoodNearbyViewWidget extends StatefulWidget {
  const PopularFoodNearbyViewWidget({super.key});

  @override
  State<PopularFoodNearbyViewWidget> createState() => _PopularFoodNearbyViewWidgetState();
}

class _PopularFoodNearbyViewWidgetState extends State<PopularFoodNearbyViewWidget> {

  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
        return (productController.popularProductList !=null && productController.popularProductList!.isEmpty) ? const SizedBox() : Padding(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isMobile(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge),
          child: SizedBox(
            height: ResponsiveHelper.isMobile(context) ? 300 : 332, width: Dimensions.webMaxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ResponsiveHelper.isDesktop(context) ?  Padding(
                  padding: const EdgeInsets.only(bottom: 45),
                  child: Text('popular_foods_nearby'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                ): Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeLarge),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('popular_foods_nearby'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    ArrowIconButtonWidget(onTap: () => Get.toNamed(RouteHelper.getPopularFoodRoute(true))),
                  ],
                )),

                Row(children: [
                    ResponsiveHelper.isDesktop(context) ? ArrowIconButtonWidget(
                      isLeft: true,
                      onTap: ()=> carouselController.previousPage(),
                    ) : const SizedBox(),

                    productController.popularProductList !=null ? Expanded(
                      child: CarouselSlider.builder(
                        carouselController: carouselController,
                        options: CarouselOptions(
                          height: ResponsiveHelper.isMobile(context) ? 240 : 260,
                          viewportFraction: ResponsiveHelper.isDesktop(context) ? 0.2 : 0.55,
                          enlargeFactor: ResponsiveHelper.isDesktop(context) ? 0.2 : 0.25,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          disableCenter: true,
                          onPageChanged: (index, reason) {

                          },
                        ),
                        itemCount: productController.popularProductList!.length,
                        itemBuilder: (context, index, _) {

                          return SizedBox(
                            child: ItemCardWidget(
                              product: productController.popularProductList![index],
                              isBestItem: true,
                              isPopularNearbyItem: true,
                            ),
                          );
                        },
                      ),
                    ) : const ItemCardShimmer(isPopularNearbyItem: true),

                    ResponsiveHelper.isDesktop(context) ? ArrowIconButtonWidget(
                      onTap: () => carouselController.nextPage(),
                    ) : const SizedBox(),
                  ],
                ),

             ],
            )
          ),
        );
      }
    );
  }
}
