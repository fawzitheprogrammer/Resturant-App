import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/features/review/controllers/review_controller.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/product_helper.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/discount_tag_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/common/widgets/not_available_widget.dart';
import 'package:stackfood_multivendor/common/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

class BestReviewedItemWidget1 extends StatelessWidget {
  const BestReviewedItemWidget1({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewController>(builder: (reviewController) {
      List<Product>? productList = reviewController.reviewedProductList;

      return (productList != null && productList.isEmpty) ? const SizedBox() : Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: TitleWidget(
              title: 'best_reviewed_food'.tr,
              onTap: () => Get.toNamed(RouteHelper.getPopularFoodRoute(false)),
            ),
          ),

          SizedBox(
            height: 230,
            child: productList != null ? ListView.builder(
              controller: ScrollController(),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeExtraSmall),
              itemCount: productList.length > 10 ? 10 : productList.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: 5),
                  child: InkWell(
                    onTap: () {
                      ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
                        ProductBottomSheetWidget(product: productList[index], isCampaign: false),
                        backgroundColor: Colors.transparent, isScrollControlled: true,
                      ) : Get.dialog(
                        Dialog(child: ProductBottomSheetWidget(product: productList[index])),
                      );
                    },
                    child: Container(
                      height: 220,
                      width: 180,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        boxShadow: const [BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5, spreadRadius: 1,
                        )],
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                        Stack(children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusSmall)),
                            child: CustomImageWidget(
                              image: '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/${productList[index].image}',
                              height: 125, width: 170, fit: BoxFit.cover,
                            ),
                          ),

                          DiscountTagWidget(
                            discount: productList[index].discount, discountType: productList[index].discountType,
                            inLeft: true, fromTop: 30,
                          ),

                          ProductHelper.isAvailable(productList[index]) ? const SizedBox() : const NotAvailableWidget(isRestaurant: true),

                          Positioned(
                            top: Dimensions.paddingSizeExtraSmall, left: Dimensions.paddingSizeExtraSmall,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Row(children: [
                                Icon(Icons.star, color: Theme.of(context).primaryColor, size: 15),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                Text(productList[index].avgRating!.toStringAsFixed(1), style: robotoRegular),
                              ]),
                            ),
                          ),

                        ]),

                        Expanded(
                          child: Stack(children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                Center(
                                  child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                                    Text(
                                      productList[index].name ?? '', textAlign: TextAlign.center,
                                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                      maxLines: 2, overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                    (Get.find<SplashController>().configModel!.toggleVegNonVeg!)
                                        ? Image.asset(productList[index].veg == 0 ? Images.nonVegImage : Images.vegImage,
                                        height: 10, width: 10, fit: BoxFit.contain,
                                    ) : const SizedBox(),
                                  ]),
                                ),
                                const SizedBox(height: 2),

                                Text(
                                  productList[index].restaurantName ?? '', textAlign: TextAlign.center,
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                                  ProductHelper.getDiscount(productList[index])! > 0  ? Flexible(child: Text(
                                    PriceConverter.convertPrice(productList[index].price),
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).colorScheme.error,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  )) : const SizedBox(),
                                  SizedBox(width: productList[index].discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                                  Text(
                                    PriceConverter.convertPrice(
                                      productList[index].price, discount: ProductHelper.getDiscount(productList[index]),
                                      discountType: ProductHelper.getDiscountType(productList[index]),
                                    ),
                                    style: robotoMedium,
                                  ),
                                ]),
                              ]),
                            ),

                            Positioned(bottom: 0, right: 0, child: Container(
                              height: 25, width: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor
                              ),
                              child: const Icon(Icons.add, size: 20, color: Colors.white),
                            )),

                          ]),
                        ),

                      ]),
                    ),
                  ),
                );
              },
            ) : BestReviewedItemShimmer(reviewController: reviewController),
          ),
        ],
      );
    });
  }
}

class BestReviewedItemShimmer extends StatelessWidget {
  final ReviewController reviewController;
  const BestReviewedItemShimmer({super.key, required this.reviewController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      itemCount: 10,
      itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: 5),
          child: Container(
            height: 220, width: 180,
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [BoxShadow(
                color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]!,
                blurRadius: 5, spreadRadius: 1,
              )],
            ),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: reviewController.reviewedProductList == null,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                Stack(children: [
                  Container(
                    height: 125, width: 170,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusSmall)),
                      color: Colors.grey[300],
                    ),
                  ),

                  Positioned(
                    top: Dimensions.paddingSizeExtraSmall, left: Dimensions.paddingSizeExtraSmall,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Row(children: [
                        Icon(Icons.star, color: Theme.of(context).primaryColor, size: 15),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text('0.0', style: robotoRegular),
                      ]),
                    ),
                  ),
                ]),

                Expanded(
                  child: Stack(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        Container(height: 15, width: 100, color: Colors.grey[300]),
                        const SizedBox(height: 2),

                        Container(height: 10, width: 70, color: Colors.grey[300]),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Container(height: 10, width: 40, color: Colors.grey[300]),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Container(height: 15, width: 40, color: Colors.grey[300]),
                        ]),
                      ]),
                    ),
                    Positioned(bottom: 0, right: 0, child: Container(
                      height: 25, width: 25,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor
                      ),
                      child: const Icon(Icons.add, size: 20, color: Colors.white),
                    )),
                  ]),
                ),

              ]),
            ),
          ),
        );
      },
    );
  }
}