import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;

class InfoViewWidget extends StatelessWidget {
  final Restaurant restaurant;
  final RestaurantController restController;
  final double scrollingRate;
  const InfoViewWidget({super.key, required this.restaurant, required this.restController, required this.scrollingRate});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
      Row(children: [

        !isDesktop ? Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).primaryColor, width: 0.2),
          ),
          padding: const EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Stack(children: [
              CustomImageWidget(
                image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}/${restaurant.logo}',
                height: 60 - (scrollingRate * 15), width: 60 - (scrollingRate * 15), fit: BoxFit.cover,
              ),
              restController.isRestaurantOpenNow(restaurant.active!, restaurant.schedules) ? const SizedBox() : Positioned(
                left: 0, right: 0, bottom: 0,
                child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(Dimensions.radiusSmall)),
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: Text(
                    'closed_now'.tr, textAlign: TextAlign.center,
                    style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                  ),
                ),
              ),
            ]),
          ),
        ) : const SizedBox(),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            restaurant.name!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge - (scrollingRate * 3), color: Theme.of(context).textTheme.bodyMedium!.color),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text(
            restaurant.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall - (scrollingRate * 2), color: Theme.of(context).disabledColor),
          ),
          SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0),

          Row(children: [
            Text('start_from'.tr, style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * 2), color: Theme.of(context).disabledColor,
            )),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Text(
              PriceConverter.convertPrice(restaurant.minimumOrder), textDirection: TextDirection.ltr,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * 2), color: Theme.of(context).primaryColor),
            ),
          ]),

        ])),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Column(children: [
          GetBuilder<FavouriteController>(builder: (favouriteController) {
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
                  isWished ? Icons.favorite : Icons.favorite_border,
                  color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                  size: 24  - (scrollingRate * 4),
                ),
              );
            }),

          const SizedBox(height: Dimensions.paddingSizeSmall),

          InkWell(
            onTap: (){
              if(isDesktop) {
                String? hostname = html.window.location.hostname;
                String protocol = html.window.location.protocol;
                String shareUrl = '$protocol//$hostname${restController.filteringUrl(restaurant.slug ?? '')}';

                Clipboard.setData(ClipboardData(text: shareUrl));
                showCustomSnackBar('restaurant_url_copied'.tr, isError: false);
              } else {
                String shareUrl = '${AppConstants.webHostedUrl}${restController.filteringUrl(restaurant.slug ?? '')}';
                Share.share(shareUrl);
              }
            },
            child: Icon(
              Icons.share, size: 20  - (scrollingRate * 4),
            ),
          ),
        ]),
        const SizedBox(width: Dimensions.paddingSizeLarge),

      ]),
      SizedBox(height: Dimensions.paddingSizeLarge - (scrollingRate * (isDesktop ? 2 : Dimensions.paddingSizeLarge))),

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Expanded(child: SizedBox()),

        Column(children: [
          Icon(Icons.access_time, color: Theme.of(context).primaryColor, size: 20 - (scrollingRate * (isDesktop ? 2 : 20))),
          // const SizedBox(height: 2),

          Text(restaurant.deliveryTime!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall - (scrollingRate * (isDesktop ? 2 : Dimensions.fontSizeSmall)), color: Theme.of(context).textTheme.bodyLarge!.color)),
        ]),
        const Expanded(child: SizedBox()),

        InkWell(
          onTap: () => Get.toNamed(RouteHelper.getMapRoute(
            AddressModel(
              id: restaurant.id, address: restaurant.address, latitude: restaurant.latitude,
              longitude: restaurant.longitude, contactPersonNumber: '', contactPersonName: '', addressType: '',
            ), 'restaurant',
          )),
          child: Column(children: [
            Image.asset(Images.restaurantLocationIcon, height: 20 - (scrollingRate * (isDesktop ? 2 : 20)), width: 20 - (scrollingRate * (isDesktop ? 2 : 20)), color: Theme.of(context).primaryColor),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Text('location'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall - (scrollingRate * (isDesktop ? 2 : Dimensions.fontSizeSmall)), color: Theme.of(context).textTheme.bodyLarge!.color)),
          ]),
        ),
        const Expanded(child: SizedBox()),

        InkWell(
          onTap: () => Get.toNamed(RouteHelper.getRestaurantReviewRoute(restaurant.id)),
          child: Column(children: [
            Row(children: [
              Icon(Icons.star, color: Theme.of(context).primaryColor, size: 20 - (scrollingRate * (isDesktop ? 2 : 20))),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Text(
                restaurant.avgRating!.toStringAsFixed(1),
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall - (scrollingRate * (isDesktop ? 2 : Dimensions.fontSizeSmall)), color: Theme.of(context).textTheme.bodyLarge!.color),
              ),
            ]),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Text(
              '${restaurant.ratingCount} + ${'ratings'.tr}',
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall - (scrollingRate * (isDesktop ? 2 : Dimensions.fontSizeSmall)), color: Theme.of(context).primaryColor),
            ),
          ]),
        ),

        (restaurant.delivery! && restaurant.freeDelivery!) ? const Expanded(child: SizedBox()) : const SizedBox(),

        (restaurant.delivery! && restaurant.freeDelivery!) ? Column(children: [
          Icon(Icons.money_off, color: Theme.of(context).primaryColor, size: 20 - (scrollingRate * (isDesktop ? 2 : 20))),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Text(
            'free_delivery'.tr,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * (isDesktop ? 2 : Dimensions.fontSizeExtraSmall)),
              color: Theme.of(context).textTheme.bodyMedium!.color!,
            ),
          ),
        ]) : const SizedBox(),

        const Expanded(child: SizedBox()),

      ]),
    ]);
  }
}