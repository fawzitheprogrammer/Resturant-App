import 'package:stackfood_multivendor/common/widgets/rating_bar_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/discount_tag_widget.dart';
import 'package:stackfood_multivendor/common/widgets/not_available_widget.dart';
import 'package:stackfood_multivendor/common/widgets/title_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

class PopularStoreWidget1 extends StatelessWidget {
  final bool isPopular;
  final bool isRecentlyViewed;
  final bool isOrderAgainViewed;
  const PopularStoreWidget1({super.key, required this.isPopular, this.isRecentlyViewed = false, this.isOrderAgainViewed = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      List<Restaurant>? restaurant = isPopular ? restaurantController.popularRestaurantList
          : isRecentlyViewed ? restaurantController.recentlyViewedRestaurantList
          : isOrderAgainViewed ? restaurantController.orderAgainRestaurantList
          : restaurantController.latestRestaurantList;

      return (restaurant != null && restaurant.isEmpty) ? const SizedBox() : Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, isPopular ? 15 : 15, 10, 10),
            child: TitleWidget(
              title: isPopular ? 'popular_restaurants'.tr
                  : isRecentlyViewed ? 'recently_viewed_restaurants'.tr
                  : isOrderAgainViewed ? 'order_again'.tr : '${'new_on'.tr} ${AppConstants.appName}',
              onTap: () => Get.toNamed(RouteHelper.getAllRestaurantRoute(isPopular ? 'popular' : isRecentlyViewed ? 'recently_viewed' : isOrderAgainViewed ? 'order_again' : 'latest')),
            ),
          ),

          SizedBox(
            height: 150,
            child: restaurant != null ? ListView.builder(
              controller: ScrollController(),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
              itemCount: restaurant.length > 10 ? 10 : restaurant.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: 5),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(
                        RouteHelper.getRestaurantRoute(restaurant[index].id),
                        arguments: RestaurantScreen(restaurant: restaurant[index]),
                      );
                    },
                    child: Container(
                      height: 150,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                        Stack(children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusSmall)),
                            child: CustomImageWidget(
                              image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}'
                                  '/${restaurant[index].coverPhoto}',
                              height: 90, width: 200, fit: BoxFit.cover,
                            ),
                          ),
                          DiscountTagWidget(
                            discount: restaurantController.getDiscount(restaurant[index]),
                            discountType: restaurantController.getDiscountType(restaurant[index]),
                            freeDelivery: restaurant[index].freeDelivery,
                          ),
                          restaurantController.isOpenNow(restaurant[index]) ? const SizedBox() : const NotAvailableWidget(isRestaurant: true),
                          Positioned(
                            top: Dimensions.paddingSizeExtraSmall, right: Dimensions.paddingSizeExtraSmall,
                            child: GetBuilder<FavouriteController>(builder: (favouriteController) {
                              bool isWished = favouriteController.wishRestIdList.contains(restaurant[index].id);
                              return InkWell(
                                onTap: () {
                                  if(Get.find<AuthController>().isLoggedIn()) {
                                    isWished ? favouriteController.removeFromFavouriteList(restaurant[index].id, true)
                                        : favouriteController.addToFavouriteList(null, restaurant[index], true);
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
                                    isWished ? Icons.favorite : Icons.favorite_border,  size: 15,
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
                                restaurant[index].name ?? '',
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),

                              Text(
                                restaurant[index].address ?? '',
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),

                              RatingBarWidget(
                                rating: restaurant[index].avgRating,
                                ratingCount: restaurant[index].ratingCount,
                                size: 12,
                              ),
                            ]),
                          ),
                        ),

                      ]),
                    ),
                  ),
                );
              },
            ) : PopularStoreShimmer(restaurantController: restaurantController),
          ),
        ],
      );
    });
  }
}

class PopularStoreShimmer extends StatelessWidget {
  final RestaurantController restaurantController;
  const PopularStoreShimmer({super.key, required this.restaurantController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      itemCount: 10,
      itemBuilder: (context, index){
        return Container(
          height: 150,
          width: 200,
          margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 10, spreadRadius: 1)]
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Container(
                height: 90, width: 200,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusSmall)),
                    color: Colors.grey[300]
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(height: 10, width: 100, color: Colors.grey[300]),
                    const SizedBox(height: 5),

                    Container(height: 10, width: 130, color: Colors.grey[300]),
                    const SizedBox(height: 5),

                    const RatingBarWidget(rating: 0.0, size: 12, ratingCount: 0),
                  ]),
                ),
              ),

            ]),
          ),
        );
      },
    );
  }
}

