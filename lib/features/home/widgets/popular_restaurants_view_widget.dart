import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/icon_with_text_row_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class PopularRestaurantsViewWidget extends StatelessWidget {
  final bool isRecentlyViewed;
  const PopularRestaurantsViewWidget({super.key, this.isRecentlyViewed = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      List<Restaurant>? restaurantList = isRecentlyViewed ? restController.recentlyViewedRestaurantList : restController.popularRestaurantList;
        return (restaurantList != null && restaurantList.isEmpty) ? const SizedBox() : Padding(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isMobile(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge),
          child: SizedBox(
            height: 232, width: Dimensions.webMaxWidth,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                ResponsiveHelper.isDesktop(context) ? Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(isRecentlyViewed ? 'your_restaurants'.tr : 'popular_restaurants'.tr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600),
                    ),

                    ArrowIconButtonWidget(onTap: () {
                      Get.toNamed(RouteHelper.getAllRestaurantRoute(isRecentlyViewed ? 'recently_viewed' : 'popular'));
                    }),
                  ]),
                ) : Padding(
                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeLarge),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(isRecentlyViewed ? 'your_restaurants'.tr : 'popular_restaurants'.tr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600),
                    ),
                    ArrowIconButtonWidget(onTap: () {
                      Get.toNamed(RouteHelper.getAllRestaurantRoute(isRecentlyViewed ? 'recently_viewed' : 'popular'));
                    }),
                  ]),
                ),


              restaurantList != null ? SizedBox(
                  height: 172,
                  child: ListView.builder(
                    itemCount: restaurantList.length,
                    padding: EdgeInsets.only(right: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      bool isAvailable = restaurantList[index].open == 1 && restaurantList[index].active!;
                      return Padding(
                        padding: EdgeInsets.only(left: (ResponsiveHelper.isDesktop(context) && index == 0 && Get.find<LocalizationController>().isLtr) ? 0 : Dimensions.paddingSizeDefault),
                        child: Container(
                          height: 172, width: 253,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          child: CustomInkWellWidget(
                            onTap: () => Get.toNamed(RouteHelper.getRestaurantRoute(restaurantList[index].id),
                              arguments: RestaurantScreen(restaurant: restaurantList[index]),
                            ),
                            radius: Dimensions.radiusDefault,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: 85, width: 253,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                                    child: Stack(
                                      children: [
                                        CustomImageWidget(
                                          placeholder: Images.placeholder,
                                          image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}'
                                              '/${restaurantList[index].coverPhoto}',
                                          fit: BoxFit.cover, height: 83, width: 253,
                                        ),

                                        !isAvailable ? Positioned(
                                          top: 0, left: 0, right: 0, bottom: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                                              color: Colors.black.withOpacity(0.3),
                                            ),
                                          ),
                                        ) : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),

                                !isAvailable ? Positioned(top: 30, left: 60, child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.error.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusLarge)
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.fontSizeExtraLarge, vertical: Dimensions.paddingSizeExtraSmall),
                                  child: Row(children: [
                                    Icon(Icons.access_time, size: 12, color: Theme.of(context).cardColor),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                    Text('closed_now'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall)),
                                  ]),
                                )) : const SizedBox(),

                                Positioned(
                                  top: 90, left: 75, right: 0,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(restaurantList[index].name!,
                                          overflow: TextOverflow.ellipsis, maxLines: 1, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)),
                                      const SizedBox(height: Dimensions.paddingSizeSmall),

                                      Text(restaurantList[index].address!,
                                          overflow: TextOverflow.ellipsis, maxLines: 1,
                                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                    ],
                                  ),
                                ),


                                Positioned(
                                  bottom: 10, left: 0, right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconWithTextRowWidget(
                                        icon: Icons.star_border,
                                        text: restaurantList[index].avgRating!.toStringAsFixed(1),
                                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeDefault),

                                      restaurantList[index].freeDelivery! ? ImageWithTextRowWidget(
                                        widget: Image.asset(Images.deliveryIcon, height: 20, width: 20),
                                        text: 'free'.tr,
                                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                      ): const SizedBox(),
                                      restaurantList[index].freeDelivery! ? const SizedBox(width: Dimensions.paddingSizeDefault) : const SizedBox(),

                                      IconWithTextRowWidget(
                                        icon: Icons.access_time_outlined,
                                        text: '${restaurantList[index].deliveryTime}',
                                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                      ),

                                    ],
                                  ),
                                ),


                                Positioned(
                                  top: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
                                  child: GetBuilder<FavouriteController>(builder: (favouriteController) {
                                    bool isWished = favouriteController.wishRestIdList.contains(restaurantList[index].id);
                                      return InkWell(
                                        onTap: () {
                                          if(Get.find<AuthController>().isLoggedIn()) {
                                            isWished ? favouriteController.removeFromFavouriteList(restaurantList[index].id, true)
                                                : favouriteController.addToFavouriteList(null, restaurantList[index], true);
                                          }else {
                                            showCustomSnackBar('you_are_not_logged_in'.tr);
                                          }
                                        },
                                        child: Icon(isWished ? Icons.favorite : Icons.favorite_border,
                                            color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, size: 20),
                                      );
                                    }
                                  ),
                                ),

                                Positioned(
                                  top: 63, right: 12,
                                  child: Container(
                                    height: 23,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                                      color: Theme.of(context).cardColor,
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                    child: Center(
                                      child: Text( '${restController.getRestaurantDistance(
                                        LatLng(double.parse(restaurantList[index].latitude!), double.parse(restaurantList[index].longitude!)),
                                      ).toStringAsFixed(2)} ${'km'.tr}',
                                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                ),



                                Positioned(
                                  top: 60, left: Dimensions.paddingSizeSmall,
                                  child: Container(
                                    height: 58, width: 58,
                                    decoration:  BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      border: Border.all(color: Theme.of(context).cardColor.withOpacity(0.2), width: 3),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    ),
                                    child: ClipRRect(
                                      child: CustomImageWidget(
                                        placeholder: Images.placeholder,
                                        image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}'
                                            '/${restaurantList[index].logo}',
                                        fit: BoxFit.cover, height: 58, width: 58,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),


                        ),
                      );
                    },
                  ),
                ) : const PopularRestaurantShimmer()
              ],
            ),

          ),
        );
      }
    );
  }
}


class PopularRestaurantShimmer extends StatelessWidget {
  const PopularRestaurantShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 172,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(left: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0, right: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
          itemCount: 7,
          itemBuilder: (context, index) {
            return Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: Container(
                margin: EdgeInsets.only(left: index == 0 ? 0 : Dimensions.paddingSizeDefault),
                height: 172, width: 253,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 85, width: 253,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                      ),
                      child: ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                          child: Container(
                              height: 85, width: 253,
                              color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],

                          )
                      ),
                    ),

                    Positioned(
                      top: 90, left: 75, right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 15, width: 100,
                              color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],

                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Container(
                              height: 15, width: 200,
                              color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                            ),

                          const SizedBox(height: Dimensions.paddingSizeSmall),
                        ],
                      ),
                    ),
                  ]
                ),
              ),
            );
          }
      ),
    );
  }
}

