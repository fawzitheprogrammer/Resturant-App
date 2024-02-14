import 'package:stackfood_multivendor/common/widgets/rating_bar_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/features/product/controllers/product_controller.dart';
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
import 'package:stackfood_multivendor/common/widgets/not_available_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/common/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

class PopularItemWidget1 extends StatelessWidget {
  final bool isPopular;
  const PopularItemWidget1({super.key, required this.isPopular});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewController>(builder: (reviewController) {
        return GetBuilder<ProductController>(builder: (productController) {
          List<Product>? productList = isPopular ? productController.popularProductList : reviewController.reviewedProductList;

          return (productList != null && productList.isEmpty) ? const SizedBox() : Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                child: TitleWidget(
                  title: isPopular ? 'popular_foods_nearby'.tr : 'best_reviewed_food'.tr,
                  onTap: () => Get.toNamed(RouteHelper.getPopularFoodRoute(isPopular)),
                ),
              ),

              SizedBox(
                height: 95,
                child: productList != null ? ListView.builder(
                  controller: ScrollController(),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                  itemCount: productList.length > 10 ? 10 : productList.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(2, 2, Dimensions.paddingSizeSmall, 2),
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
                          height: 90, width: 250,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                          ),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                            Stack(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                child: CustomImageWidget(
                                  image: '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}'
                                      '/${productList[index].image}',
                                  height: 80, width: 80, fit: BoxFit.cover,
                                ),
                              ),
                              DiscountTagWidget(
                                discount: ProductHelper.getDiscount(productList[index]),
                                discountType: ProductHelper.getDiscountType(productList[index]),
                              ),
                              ProductHelper.isAvailable(productList[index]) ? const SizedBox() : const NotAvailableWidget(),
                            ]),

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                                  Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                                    Text(
                                      productList[index].name!,
                                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                    (Get.find<SplashController>().configModel!.toggleVegNonVeg!)
                                        ? Image.asset(productList[index].veg == 0 ? Images.nonVegImage : Images.vegImage,
                                      height: 10, width: 10, fit: BoxFit.contain,
                                    ) : const SizedBox(),
                                  ]),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                  Text(
                                    productList[index].restaurantName!,
                                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                  ),

                                  RatingBarWidget(
                                    rating: productList[index].avgRating, size: 12,
                                    ratingCount: productList[index].ratingCount,
                                  ),

                                  Row(children: [
                                    Expanded(
                                      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                        productList[index].discount! > 0 ? Flexible(child: Text(
                                          PriceConverter.convertPrice(productList[index].price),
                                          style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).colorScheme.error,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        )) : const SizedBox(),
                                        SizedBox(width: productList[index].discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),
                                        Text(
                                          PriceConverter.convertPrice(
                                            productList[index].price, discount: productList[index].discount,
                                            discountType: productList[index].discountType,
                                          ),
                                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                        ),
                                      ]),
                                    ),
                                    Container(
                                      height: 25, width: 25,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).primaryColor
                                      ),
                                      child: const Icon(Icons.add, size: 20, color: Colors.white),
                                    ),
                                  ]),
                                ]),
                              ),
                            ),

                          ]),
                        ),
                      ),
                    );
                  },
                ) : PopularItemShimmer(enabled: productList == null),
              ),
            ],
          );
        });
      }
    );
  }
}

class PopularItemShimmer extends StatelessWidget {
  final bool enabled;
  const PopularItemShimmer({super.key, required this.enabled});

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
          padding: const EdgeInsets.fromLTRB(2, 2, Dimensions.paddingSizeSmall, 2),
          child: Container(
            height: 90, width: 250,
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
              duration: const Duration(seconds: 1),
              interval: const Duration(seconds: 1),
              enabled: enabled,
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                Container(
                  height: 80, width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Colors.grey[300],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(height: 15, width: 100, color: Colors.grey[300]),
                      const SizedBox(height: 5),

                      Container(height: 10, width: 130, color: Colors.grey[300]),
                      const SizedBox(height: 5),

                      const RatingBarWidget(rating: 0, size: 12, ratingCount: 0),

                      Row(children: [
                        Expanded(
                          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            Container(height: 10, width: 40, color: Colors.grey[300]),
                            Container(height: 15, width: 40, color: Colors.grey[300]),
                          ]),
                        ),
                        Container(
                          height: 25, width: 25,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor
                          ),
                          child: const Icon(Icons.add, size: 20, color: Colors.white),
                        ),
                      ]),
                    ]),
                  ),
                ),

              ]),
            ),
          ),
        );
      },
    );
  }
}

