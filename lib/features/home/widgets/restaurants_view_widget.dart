import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/icon_with_text_row_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
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

class RestaurantsViewWidget extends StatelessWidget {
  final List<Restaurant?>? restaurants;
  const RestaurantsViewWidget({super.key, this.restaurants});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.webMaxWidth,
      child: restaurants != null ? restaurants!.isNotEmpty ? GridView.builder(
        shrinkWrap: true,
        itemCount: restaurants!.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : ResponsiveHelper.isTab(context) ? 3 : 4,
          mainAxisSpacing: Dimensions.paddingSizeLarge,
          crossAxisSpacing: Dimensions.paddingSizeLarge,
          mainAxisExtent: 210,
        ),
        padding: EdgeInsets.symmetric(horizontal: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : 0),
        itemBuilder: (context, index) {
          return restaurantView(context, restaurants![index]!);
        },
      ) : Center(child: Padding(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeOverLarge),
        child: Text('no_restaurant_available'.tr, style: robotoMedium),
      )) : GridView.builder(
        shrinkWrap: true,
        itemCount: 12,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : ResponsiveHelper.isTab(context) ? 3 : 4,
          mainAxisSpacing: Dimensions.paddingSizeLarge,
          crossAxisSpacing: Dimensions.paddingSizeLarge,
          mainAxisExtent: 210,
        ),
        padding: EdgeInsets.symmetric(horizontal: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),
        itemBuilder: (context, index) {
          return const WebRestaurantShimmer();
        },
      ),

    );
  }

  Widget restaurantView(BuildContext context, Restaurant restaurant) {
    bool isAvailable = restaurant.open == 1 && restaurant.active!;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: CustomInkWellWidget(
        onTap: () {
          if(restaurant.restaurantStatus == 1){
            Get.toNamed(RouteHelper.getRestaurantRoute(restaurant.id), arguments: RestaurantScreen(restaurant: restaurant));
          }else if(restaurant.restaurantStatus == 0){
            showCustomSnackBar('restaurant_is_not_available'.tr);
          }
        },
        radius: Dimensions.radiusDefault,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                child: CustomImageWidget(
                  image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}'
                      '/${restaurant.coverPhoto}',
                  fit: BoxFit.cover, height: 93, width: double.infinity,
                ),
              ),
            ),

            !isAvailable ? Positioned(top: 10, left: 10, child: Container(
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
              top: 60, left: 10, right: 0,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    height: 70, width: 70,
                    decoration:  BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImageWidget(
                        image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}'
                            '/${restaurant.logo}',
                        fit: BoxFit.cover, height: 70, width: 70,
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text(
                    restaurant.name!,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(
                    restaurant.address!,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconWithTextRowWidget(
                        icon: Icons.star_border, text: restaurant.avgRating.toString(),
                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                      ),

                      restaurant.freeDelivery! ? Padding(
                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                        child: ImageWithTextRowWidget(
                          widget: Image.asset(Images.deliveryIcon, height: 20, width: 20),
                          text: 'free'.tr,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                        ),
                      ) : const SizedBox(),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      IconWithTextRowWidget(
                        icon: Icons.access_time_outlined, text: '${restaurant.deliveryTime}',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                      ),

                    ],
                  ),
                ],
              ),
            ),

            Positioned(
              top: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
              child: GetBuilder<FavouriteController>(builder: (favouriteController) {
                bool isWished = favouriteController.wishRestIdList.contains(restaurant.id);
                return InkWell(
                  onTap: () {
                    if(Get.find<AuthController>().isLoggedIn()) {
                      isWished ? favouriteController.removeFromFavouriteList(restaurant.id, true)
                          : favouriteController.addToFavouriteList(null, restaurant, true);
                    }else {
                      showCustomSnackBar('you_are_not_logged_in'.tr);
                    }
                  },
                  child: Icon(
                    Icons.favorite,  size: 20,
                    color: isWished ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.4),
                  ),
                );
              }),
            ),

            Positioned(
              top: 73, right: 5,
              child: Container(
                height: 23,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                  color: Theme.of(context).cardColor,
                ),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                child: Center(
                  child: Text('${Get.find<RestaurantController>().getRestaurantDistance(
                    LatLng(double.parse(restaurant.latitude!), double.parse(restaurant.longitude!)),
                  ).toStringAsFixed(2)} ${'km'.tr}',
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor)),
                ),
              ),
            ),
          ],
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
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        child: Container(
          // height: 172, width: 290,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 93, width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radiusDefault),
                    topRight: Radius.circular(Dimensions.radiusDefault),
                  ),
                ),
              ),

              Positioned(
                top: 60, left: 10, right: 0,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      height: 70, width: 70,
                      decoration:  BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(height: 15, width: 100, color: Colors.black.withOpacity(0.1)),
                    const SizedBox(height: 5),

                    Container(height: 10, width: 130, color: Colors.black.withOpacity(0.1)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconWithTextRowWidget(
                          icon: Icons.star_border, text: '5.0',
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                          child: ImageWithTextRowWidget(
                            widget: Image.asset(Images.deliveryIcon, height: 20, width: 20),
                            text: 'free'.tr,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        IconWithTextRowWidget(
                          icon: Icons.access_time_outlined, text: '10-30 min',
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                        ),

                      ],
                    ),
                  ],
                ),
              ),

              Positioned(
                top: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
                child: Icon(
                  Icons.favorite,  size: 20,
                  color: Theme.of(context).primaryColor.withOpacity(0.4),
                ),
              ),

              Positioned(
                top: 73, right: 5,
                child: Container(
                  height: 23,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                    color: Theme.of(context).cardColor,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                  child: Center(
                    child: Text('5 ${'km'.tr}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}