import 'package:stackfood_multivendor/common/widgets/hover_widgets/on_hover_widget.dart';
import 'package:stackfood_multivendor/common/widgets/rating_bar_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/discount_tag_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebProductWidget extends StatelessWidget {
  final Product? product;
  final Restaurant? restaurant;
  final bool isRestaurant;
  final int index;
  final int? length;
  final bool inRestaurant;
  final bool isCampaign;
  final bool isFeatured;
  final bool fromCartSuggestion;
  const WebProductWidget({super.key, required this.product, required this.isRestaurant, required this.restaurant, required this.index,
    required this.length, this.inRestaurant = false, this.isCampaign = false, this.isFeatured = false, this.fromCartSuggestion = false});

  @override
  Widget build(BuildContext context) {
    // final bool ltr = Get.find<LocalizationController>().isLtr;
    BaseUrls? baseUrls = Get.find<SplashController>().configModel!.baseUrls;
    bool desktop = ResponsiveHelper.isDesktop(context);
    double? discount;
    String? discountType;
    // bool isAvailable;
    if(isRestaurant) {
      discount = restaurant!.discount != null ? restaurant!.discount!.discount : 0;
      discountType = restaurant!.discount != null ? restaurant!.discount!.discountType : 'percent';
      // bool _isClosedToday = Get.find<StoreController>().isRestaurantClosed(true, store.active, store.offDay);
      // _isAvailable = DateConverter.isAvailable(store.openingTime, store.closeingTime) && store.active && !_isClosedToday;
      // isAvailable = store!.open == 1 && store!.active!;
    }else {
      discount = (product!.restaurantDiscount == 0 || isCampaign) ? product!.discount : product!.restaurantDiscount;
      discountType = (product!.restaurantDiscount == 0 || isCampaign) ? product!.discountType : 'percent';
      // isAvailable = DateConverter.isAvailable(item!.availableTimeStarts, item!.availableTimeEnds);
    }

    return InkWell(
      onTap: () {
        if(isRestaurant) {
          if(restaurant != null && restaurant!.restaurantStatus == 1){
            Get.toNamed(RouteHelper.getRestaurantRoute(restaurant!.id), arguments: RestaurantScreen(restaurant: restaurant));
          }else if(restaurant!.restaurantStatus == 0){
            showCustomSnackBar('restaurant_is_not_available'.tr);
          }
        }else {
          if(product!.restaurantStatus == 1){
            ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
              ProductBottomSheetWidget(product: product, inRestaurantPage: inRestaurant, isCampaign: isCampaign),
              backgroundColor: Colors.transparent, isScrollControlled: true,
            ) : Get.dialog(
              Dialog(child: ProductBottomSheetWidget(product: product, inRestaurantPage: inRestaurant)),
            );
          }else{
            showCustomSnackBar('item_is_not_available'.tr);
          }
        }
      },
      child: OnHoverWidget(
        isItem: true,
        child: Stack(
          children: [
            Container(
              margin: ResponsiveHelper.isDesktop(context) ? null : const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: Theme.of(context).cardColor,
                border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.5)),
              ),
              padding: const EdgeInsets.all(1),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [

                Expanded(child: Column(children: [
                  Stack(children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusSmall), topRight: Radius.circular(Dimensions.radiusSmall)),
                      child: CustomImageWidget(
                        image: '${isCampaign ? baseUrls!.campaignImageUrl : isRestaurant ? baseUrls!.restaurantImageUrl
                            : baseUrls!.productImageUrl}'
                            '/${isRestaurant ? restaurant != null ? restaurant!.logo : '' : product!.image}',
                        height: desktop ? 160 : length == null ? 100 : 65, width: desktop ? isRestaurant ? 275 : 300 : 80, fit: BoxFit.cover,
                      ),
                    ),

                    DiscountTagWidget(
                      discount: product!.discount, discountType: product!.discountType,
                      inLeft: true,
                    ),
                  ]),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: SizedBox(
                        width: desktop ? isRestaurant ? 275 :219 : 80,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max ,mainAxisAlignment: MainAxisAlignment.center, children: [

                          Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                            Text(
                              isRestaurant ? restaurant!.name! : product!.name!,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                              maxLines: desktop ? 1 : 1, overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                            (Get.find<SplashController>().configModel!.toggleVegNonVeg!)
                                ? Image.asset(product != null && product!.veg == 0
                                ? Images.nonVegImage : Images.vegImage,
                                height: 10, width: 10, fit: BoxFit.contain) : const SizedBox(),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          (isRestaurant ? restaurant!.address != null : product!.restaurantName != null) ? Text(
                            isRestaurant ? restaurant!.address ?? '' : product!.restaurantName ?? '',
                            style: robotoRegular.copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Theme.of(context).disabledColor,
                            ),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ) : const SizedBox(),
                          SizedBox(height: ((desktop || isRestaurant) && (isRestaurant ? restaurant!.address != null : product!.restaurantName != null)) ? 5 : 0),

                          // !isStore ? RatingBar(
                          //   rating: isStore ? store!.avgRating : item!.avgRating, size: desktop ? 15 : 12,
                          //   ratingCount: isStore ? store!.ratingCount : item!.ratingCount,
                          // ) : const SizedBox(),
                          // SizedBox(height: (!isStore && desktop) ? Dimensions.paddingSizeExtraSmall : 0),

                          // (Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! && item != null && item!.unitType != null) ? Text(
                          //   '(${ item!.unitType ?? ''})',
                          //   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor),
                          // ) : const SizedBox(),

                          isRestaurant ? RatingBarWidget(
                            rating: isRestaurant ? restaurant!.avgRating : product!.avgRating, size: desktop ? 15 : 12,
                            ratingCount: isRestaurant ? restaurant!.ratingCount : product!.ratingCount,
                          ) : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  PriceConverter.convertPrice(product!.price, discount: discount, discountType: discountType),
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall), textDirection: TextDirection.ltr,
                                ),
                                SizedBox(width: discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                                discount > 0 ? Text(
                                  PriceConverter.convertPrice(product!.price),
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: Theme.of(context).disabledColor,
                                    decoration: TextDecoration.lineThrough,
                                  ), textDirection: TextDirection.ltr,
                                ) : const SizedBox(),
                              ],
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(50)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.star, color: Theme.of(context).primaryColor, size: 12),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                    product!.ratingCount.toString(),
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                                  ),
                                ],
                              ),
                            )


                          ]),
                        ]),
                      ),
                    ),
                  ),

                ])),

              ]),
            ),

          ],
        ),
      ),
    );
  }
}