import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantDescriptionViewWidget extends StatelessWidget {
  final Restaurant? restaurant;
  const RestaurantDescriptionViewWidget({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    bool isAvailable = Get.find<RestaurantController>().isRestaurantOpenNow(restaurant!.active!, restaurant!.schedules);
    Color? textColor = ResponsiveHelper.isDesktop(context) ? Colors.white : null;

    return Column(children: [
      ResponsiveHelper.isDesktop(context) ? Row(children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          child: Stack(children: [
            CustomImageWidget(
              image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}/${restaurant!.logo}',
              height: ResponsiveHelper.isDesktop(context) ? 120 : 60, width: ResponsiveHelper.isDesktop(context) ? 130 : 70, fit: BoxFit.cover,
            ),
            isAvailable ? const SizedBox() : Positioned(
              bottom: 0, left: 0, right: 0,
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
        const SizedBox(width: Dimensions.paddingSizeSmall),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            restaurant!.name!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: textColor),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeExtraSmall),

          Text(
            restaurant!.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
          ),
          SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0),

          Row(children: [
            Text('minimum_order'.tr, style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
            )),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Text(
              PriceConverter.convertPrice(restaurant!.minimumOrder), textDirection: TextDirection.ltr,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
            ),
          ]),
        ])),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        GetBuilder<FavouriteController>(builder: (wishController) {
          bool isWished = wishController.wishRestIdList.contains(restaurant!.id);
          return InkWell(
            onTap: () {
              if(Get.find<AuthController>().isLoggedIn()) {
                isWished ? wishController.removeFromFavouriteList(restaurant!.id, true)
                    : wishController.addToFavouriteList(null, restaurant, true);
              }else {
                showCustomSnackBar('you_are_not_logged_in'.tr);
              }
            },
            child: ResponsiveHelper.isDesktop(context) ? Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusDefault), border : Border.all(color: Colors.white)),
              child: Center(
                child: Row(
                  children: [
                    Icon(isWished ? Icons.favorite : Icons.favorite_border, color: Colors.white, size: 14),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Text('wish_list'.tr, style: robotoRegular.copyWith(fontWeight: FontWeight.w200, color: Colors.white, fontSize: Dimensions.fontSizeSmall)),
                  ],
                ),
              ),
            ) :Icon(
              isWished ? Icons.favorite : Icons.favorite_border,
              color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
            ),
          );
        }),

      ]) : const SizedBox(),
      SizedBox(height: ResponsiveHelper.isDesktop(context) ? 30 : Dimensions.paddingSizeSmall),

      IntrinsicHeight(
        child: Row(children: [
          const Expanded(child: SizedBox()),
          InkWell(
            onTap: () => Get.toNamed(RouteHelper.getRestaurantReviewRoute(restaurant!.id)),
            child: Column(children: [
              Row(children: [
                Icon(Icons.star, color: Theme.of(context).primaryColor, size: 20),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(
                  restaurant!.avgRating!.toStringAsFixed(1),
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: textColor),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Text(
                '${restaurant!.ratingCount} + ${'ratings'.tr}',
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: textColor),
              ),
            ]),
          ),
          const Expanded(child: SizedBox()),

          const VerticalDivider(color: Colors.white, thickness: 1),
          const Expanded(child: SizedBox()),

          InkWell(
            onTap: () => Get.toNamed(RouteHelper.getMapRoute(
              AddressModel(
                id: restaurant!.id, address: restaurant!.address, latitude: restaurant!.latitude,
                longitude: restaurant!.longitude, contactPersonNumber: '', contactPersonName: '', addressType: '',
              ), 'restaurant',
            )),
            child: Column(children: [
              // Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 20),
              Image.asset(Images.restaurantLocationIcon, height: 20, width: 20),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Text('location'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: textColor)),
            ]),
          ),
          const Expanded(child: SizedBox()),
          const VerticalDivider(color: Colors.white, thickness: 1),
          const Expanded(child: SizedBox()),

          Column(children: [
            Row(children: [
              // Icon(Icons.timer, color: Theme.of(context).primaryColor, size: 20),
              Image.asset(Images.restaurantDeliveryTimeIcon, height: 20, width: 20),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            ]),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Text(restaurant!.deliveryTime!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: textColor)),
          ]),
          (restaurant!.delivery! && restaurant!.freeDelivery!) ? const Expanded(child: SizedBox()) : const SizedBox(),
          (restaurant!.delivery! && restaurant!.freeDelivery!) ? Column(children: [
            Icon(Icons.money_off, color: Theme.of(context).primaryColor, size: 20),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Text('free_delivery'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: textColor)),
          ]) : const SizedBox(),
          const Expanded(child: SizedBox()),
        ]),
      ),

    ]);
  }
}