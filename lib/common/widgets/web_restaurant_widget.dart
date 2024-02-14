import 'package:stackfood_multivendor/common/widgets/hover_widgets/on_hover_widget.dart';
import 'package:stackfood_multivendor/common/widgets/rating_bar_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/discount_tag_widget.dart';
import 'package:stackfood_multivendor/common/widgets/not_available_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
class WebRestaurantWidget extends StatelessWidget {
  final Restaurant? restaurant;
  const WebRestaurantWidget({super.key, this.restaurant});

  @override
  Widget build(BuildContext context) {
    return OnHoverWidget(
      isItem: true,
      child: InkWell(
        onTap: (){
          if(restaurant != null && restaurant!.restaurantStatus == 1){
            Get.toNamed(RouteHelper.getRestaurantRoute(restaurant!.id), arguments: RestaurantScreen(restaurant: restaurant));
          }else if(restaurant!.restaurantStatus == 0){
            showCustomSnackBar('restaurant_is_not_available'.tr);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

              Stack(children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusSmall)),
                  child: CustomImageWidget(
                    image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}'
                        '/${restaurant!.coverPhoto}',
                    height: 120, width: 300, fit: BoxFit.cover,
                  ),
                ),
                DiscountTagWidget(
                  discount: restaurant!.discount != null
                      ? restaurant!.discount!.discount : 0,
                  discountType: 'percent', freeDelivery: restaurant!.freeDelivery,
                ),
                Get.find<RestaurantController>().isOpenNow(restaurant!) ? const SizedBox() : const NotAvailableWidget(isRestaurant: true),
                Positioned(
                  top: Dimensions.paddingSizeExtraSmall, right: Dimensions.paddingSizeExtraSmall,
                  child: GetBuilder<FavouriteController>(builder: (wishController) {
                    bool isWished = wishController.wishRestIdList.contains(restaurant!.id);
                    return InkWell(
                      onTap: () {
                        if(Get.find<AuthController>().isLoggedIn()) {
                          isWished ? wishController.removeFromFavouriteList(restaurant!.id, true)
                              : wishController.addToFavouriteList(null, restaurant!, true);
                        }else {
                          showCustomSnackBar('you_are_not_logged_in'.tr);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                        child: Icon(
                          isWished ? Icons.favorite : Icons.favorite_border,  size: 20,
                          color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                        ),
                      ),
                    );
                  }),
                ),
              ]),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      restaurant!.name!,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text(
                      restaurant!.address!,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    RatingBarWidget(
                      rating: restaurant!.avgRating,
                      ratingCount: restaurant!.ratingCount,
                      size: 15,
                    ),
                  ]),
                ),
              ),

            ]),
          ),
        ),
      ),
    );
  }
}

class WebRestaurantShimmer extends StatelessWidget {
  const WebRestaurantShimmer({super.key, });

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Container(
            height: 120, width: 300,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusSmall)),
                color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(height: 15, width: 100, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
                const SizedBox(height: 5),

                Container(height: 10, width: 130, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
                const SizedBox(height: 5),

                const RatingBarWidget(rating: 0.0, size: 12, ratingCount: 0),
              ]),
            ),
          ),

        ]),
      ),
    );
  }
}
