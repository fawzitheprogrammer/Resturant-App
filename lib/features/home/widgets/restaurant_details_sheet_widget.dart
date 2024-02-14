import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class RestaurantDetailsSheetWidget extends StatelessWidget {
  final Function(int index) callback;
  const RestaurantDetailsSheetWidget({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      return GetBuilder<SplashController>(builder: (splashController) {
        Restaurant restaurant = restaurantController.restaurantModel!.restaurants![splashController.nearestRestaurantIndex];

        return Stack(children: [

          InkWell(
            onTap: () {
              Get.toNamed(
                RouteHelper.getRestaurantRoute(restaurant.id),
                arguments: RestaurantScreen(restaurant: restaurant),
              );
            },
            child: Container(
              width: context.width, height: 310,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: ResponsiveHelper.isMobile(context) ? const BorderRadius.vertical(top: Radius.circular(30))
                    : const BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge)),
              ),
              child: Column(children: [

                InkWell(
                  onTap: () => Get.find<SplashController>().setNearestRestaurantIndex(-1),
                  child: const Icon(Icons.keyboard_arrow_down_rounded, size: 30),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Stack(children: [

                  ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusDefault), child: CustomImageWidget(
                    image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}/${restaurant.coverPhoto}',
                    height: 180, width: context.width, fit: BoxFit.cover,
                  )),

                  restaurant.discount != null ? Positioned(
                    left: 5, bottom: 5, right: 5,
                    child: Container(
                      height: 40, width: context.width,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black38, Colors.black45, Colors.black87, Colors.black],
                          begin: Alignment.centerLeft, end: Alignment.centerRight,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          restaurant.discount!.discountType == 'percent' ? '${restaurant.discount!.discount}% OFF'
                              : '${PriceConverter.convertPrice(restaurant.discount!.discount)} OFF',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor),
                        ),
                      ),
                    ),
                  ) : const SizedBox(),

                  Positioned(
                    left: 10, bottom: 10,
                    child: Container(
                      height: 80, width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).cardColor, width: 2),
                      ),
                      child: ClipRRect(borderRadius: BorderRadius.circular(50),
                        child: CustomImageWidget(
                          image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}/${restaurant.logo}',
                          placeholder: Images.restaurantPlaceholder,
                          height: 80, width: 80, fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(children: [

                  Expanded(child: Text(restaurant.name!, maxLines: 1, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault))),

                  Icon(Icons.star, color: Theme.of(context).primaryColor, size: 18),
                  Text(
                    restaurant.avgRating!.toStringAsFixed(1),
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                  ),
                  Text('(${restaurant.ratingCount})', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor)),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(children: [

                  Icon(Icons.location_on_rounded, color: Theme.of(context).disabledColor, size: 20),
                  Expanded(child: Text(
                    restaurant.address ?? 'no_address_found'.tr, maxLines: 2,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  )),

                  Text('${(Geolocator.distanceBetween(
                    double.parse(restaurant.latitude!), double.parse(restaurant.longitude!),
                    double.parse(AddressHelper.getAddressFromSharedPref()!.latitude!),
                    double.parse(AddressHelper.getAddressFromSharedPref()!.longitude!),
                  )/1000).toStringAsFixed(1)} ${'km'.tr}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                  const SizedBox(width: Dimensions.paddingSizeLarge),

                  restaurant.freeDelivery! ?  Row(children: [
                    Icon(Icons.delivery_dining, color: Theme.of(context).primaryColor, size: 20),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Text('free'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  ]) : const SizedBox(),

                ]),

              ]),
            ),
          ),

          GetPlatform.isWeb ? const SizedBox() : splashController.nearestRestaurantIndex != (restaurantController.restaurantModel!.restaurants!.length-1) ? Positioned(
            top: 0, bottom: 0, left: 0,
            child: InkWell(
              onTap: () {
                  splashController.setNearestRestaurantIndex(splashController.nearestRestaurantIndex+1);
                  callback(splashController.nearestRestaurantIndex);
              },
              child: Container(
                height: 40, width: 40, alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Theme.of(context).cardColor.withOpacity(0.8),
                ),
                child: const Icon(Icons.arrow_back_ios_rounded),
              ),
            ),
          ) : const SizedBox(),

          GetPlatform.isWeb ? const SizedBox() : splashController.nearestRestaurantIndex != 0 ? Positioned(
            top: 0, bottom: 0, right: 0,
            child: InkWell(
              onTap: () {
                splashController.setNearestRestaurantIndex(splashController.nearestRestaurantIndex-1);
                callback(splashController.nearestRestaurantIndex);
              },
              child: Container(
                height: 40, width: 40, alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Theme.of(context).cardColor.withOpacity(0.8),
                ),
                child: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
          ) : const SizedBox(),

        ]);
      });
    });
  }
}
