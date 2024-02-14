import 'package:stackfood_multivendor/common/widgets/rating_bar_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
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

class RestaurantWidget extends StatelessWidget {
  final Restaurant? restaurant;
  final int index;
  final bool inStore;
  const RestaurantWidget({super.key, required this.restaurant, required this.index, this.inStore = false});

  @override
  Widget build(BuildContext context) {
    BaseUrls baseUrls = Get.find<SplashController>().configModel!.baseUrls!;
    bool desktop = ResponsiveHelper.isDesktop(context);
    return InkWell(
      onTap: () {

        if(restaurant != null && restaurant!.restaurantStatus == 1){
          Get.toNamed(
            RouteHelper.getRestaurantRoute(restaurant!.id),
            arguments: RestaurantScreen(restaurant: restaurant),
          );
        }else if(restaurant!.restaurantStatus == 0){
          showCustomSnackBar('restaurant_is_not_available'.tr);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          color: Theme.of(context).cardColor,
          boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Stack(children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusSmall)),
              child: CustomImageWidget(
                image: '${baseUrls.restaurantCoverPhotoUrl}/${restaurant!.coverPhoto}',
                height: context.width * 0.3, width: Dimensions.webMaxWidth, fit: BoxFit.cover,
              )
            ),
            DiscountTagWidget(
              discount: Get.find<RestaurantController>().getDiscount(restaurant!),
              discountType: Get.find<RestaurantController>().getDiscountType(restaurant!),
              freeDelivery: restaurant!.freeDelivery,
            ),
            Get.find<RestaurantController>().isOpenNow(restaurant!) ? const SizedBox() : const NotAvailableWidget(isRestaurant: true),
          ]),

          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Row(children: [

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                  Text(
                    restaurant!.name!,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    maxLines: desktop ? 2 : 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  (restaurant!.address != null) ? Text(
                    restaurant!.address ?? '',
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Theme.of(context).disabledColor,
                    ),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ) : const SizedBox(),
                  SizedBox(height: restaurant!.address != null ? 2 : 0),

                  RatingBarWidget(
                    rating: restaurant!.avgRating, size: desktop ? 15 : 12,
                    ratingCount: restaurant!.ratingCount,
                  ),

                ]),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              GetBuilder<FavouriteController>(builder: (favouriteController) {
                bool isWished = favouriteController.wishRestIdList.contains(restaurant!.id);
                return InkWell(
                  onTap: () {
                    if(Get.find<AuthController>().isLoggedIn()) {
                      isWished ? favouriteController.removeFromFavouriteList(restaurant!.id, true)
                          : favouriteController.addToFavouriteList(null, restaurant, true);
                    }else {
                      showCustomSnackBar('you_are_not_logged_in'.tr);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: desktop ? Dimensions.paddingSizeSmall : 0),
                    child: Icon(
                      isWished ? Icons.favorite : Icons.favorite_border,  size: desktop ? 30 : 25,
                      color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                    ),
                  ),
                );
              }),

            ]),
          )),

        ]),
      ),
    );
  }
}

class RestaurantShimmer extends StatelessWidget {
  final bool isEnable;
  const RestaurantShimmer({super.key, required this.isEnable});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(
          color: Colors.grey[Get.isDarkMode ? 800 : 300]!, spreadRadius: 1, blurRadius: 5,
        )],
      ),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        enabled: isEnable,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Container(
            height: context.width * 0.3, width: Dimensions.webMaxWidth,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusSmall)),
              color: Colors.grey[300],
            ),
          ),

          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Row(children: [

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                  Container(height: 15, width: 150, color: Colors.grey[300]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Container(height: 10, width: 50, color: Colors.grey[300]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  const RatingBarWidget(rating: 0, size: 12, ratingCount: 0),

                ]),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Icon(Icons.favorite_border,  size: 25, color: Theme.of(context).disabledColor),

            ]),
          )),

        ]),
      ),
    );
  }
}

