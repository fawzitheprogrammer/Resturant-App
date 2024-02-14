import 'package:stackfood_multivendor/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/widgets/coupon_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/customizable_space_bar_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/widgets/info_view_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

class RestaurantInfoSectionWidget extends StatelessWidget {
  final Restaurant restaurant;
  final RestaurantController restController;
  const RestaurantInfoSectionWidget({super.key, required this.restaurant, required this.restController});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    final double xyz = MediaQuery.of(context).size.width-1170;
    final double realSpaceNeeded = xyz/2;

    return SliverAppBar(
      expandedHeight: isDesktop ? 350 : 400,
      toolbarHeight: isDesktop ? 150 : 100,
      pinned: true, floating: false, elevation: 0.5,
      backgroundColor: Theme.of(context).cardColor,
      leading: !isDesktop ? IconButton(
        icon: Container(
          height: 50, width: 50,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
          alignment: Alignment.center,
          padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
          child: Icon(Icons.chevron_left, color: Theme.of(context).cardColor, size: 28),
        ),
        onPressed: () => Get.back(),
      ) : const SizedBox(),

      flexibleSpace: GetBuilder<CouponController>(
        builder: (couponController) {
          bool hasCoupon = (Get.find<CouponController>().couponList!= null && Get.find<CouponController>().couponList!.isNotEmpty);
          return Container(
            margin: isDesktop ? EdgeInsets.symmetric(horizontal: realSpaceNeeded) : EdgeInsets.zero,
            child: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              centerTitle: true,
              expandedTitleScale: isDesktop ? 1 : 1.1,
              title: CustomizableSpaceBarWidget(
                builder: (context, scrollingRate) {
                  return !isDesktop ? Container(
                    color: Theme.of(context).cardColor.withOpacity(scrollingRate),
                    padding: EdgeInsets.only(
                      bottom: 0,
                      left: Get.find<LocalizationController>().isLtr ? 40 * scrollingRate : 0,
                      right: Get.find<LocalizationController>().isLtr ? 0 : 40 * scrollingRate,
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        height: (hasCoupon ? 260 : 160) - (scrollingRate * 25),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1 - (0.1 * scrollingRate)), blurRadius: 10)]
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                        padding: EdgeInsets.only(
                          left: Get.find<LocalizationController>().isLtr ? 20 : 0,
                          right: Get.find<LocalizationController>().isLtr ? 0 : 20,
                          top: scrollingRate * (context.height * 0.052)
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall - (scrollingRate * Dimensions.paddingSizeSmall)),
                          child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [

                            InfoViewWidget(restaurant: restaurant, restController: restController, scrollingRate: scrollingRate),
                            SizedBox(height: Dimensions.paddingSizeLarge - (scrollingRate * (isDesktop ? 2 : Dimensions.paddingSizeLarge))),

                            scrollingRate < 0.8 ? CouponViewWidget(scrollingRate: scrollingRate) : const SizedBox(),

                          ]),
                        ),
                      ),
                    ),
                  ) : Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: restaurant.announcementActive! ? 200 : 160,
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                      child: Column(
                        children: [
                          restaurant.announcementActive != null && restaurant.announcementActive! && restaurant.announcementMessage != null ? Container(
                            height: 40 - (scrollingRate * 40),
                            padding: EdgeInsets.only(
                              left: Get.find<LocalizationController>().isLtr ? 250 : 20,
                              right: Get.find<LocalizationController>().isLtr ? 20 : 250,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                            ),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Image.asset(Images.announcement, height: 26, width: 26),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Flexible(
                                child: Marquee(
                                  text: restaurant.announcementMessage!,
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                                  blankSpace: 20.0,
                                  velocity: 100.0,
                                  accelerationDuration: const Duration(seconds: 5),
                                  decelerationDuration: const Duration(milliseconds: 500),
                                  accelerationCurve: Curves.linear,
                                  decelerationCurve: Curves.easeOut,
                                ),
                              ),
                            ]),
                          ) : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Row(children: [

                                  SizedBox(width: context.width * 0.17 - (scrollingRate * 90)),

                                  Expanded(child: InfoViewWidget(restaurant: restaurant, restController: restController, scrollingRate: scrollingRate)),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  Expanded(child: CouponViewWidget(scrollingRate: scrollingRate)),

                                ]),

                                Positioned(left: Get.find<LocalizationController>().isLtr ? 30 : null, right: Get.find<LocalizationController>().isLtr ? null : 30, top: - 80 + (scrollingRate * 77), child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).cardColor,
                                    border: Border.all(color: Theme.of(context).primaryColor, width: 0.2),
                                    boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.3), blurRadius: 10)]
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(500),
                                    child: Stack(children: [
                                      CustomImageWidget(
                                        image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}/${restaurant.logo}',
                                        height: 200 - (scrollingRate * 90), width: 200 - (scrollingRate * 90), fit: BoxFit.cover,
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
                                ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              background: Container(
                margin: EdgeInsets.only(bottom: isDesktop ? 100 : (hasCoupon ? 200 : 100)),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(Dimensions.radiusLarge)),
                  child: CustomImageWidget(
                    height: 100,
                    fit: BoxFit.cover, placeholder: Images.restaurantCover,
                    image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}/${restaurant.coverPhoto}',
                  ),
                ),
              ),
            ),
          );
        }
      ),
      actions: const [SizedBox()],
    );
  }
}