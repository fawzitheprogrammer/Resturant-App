import 'package:stackfood_multivendor/features/home/screens/home_screen.dart';
import 'package:stackfood_multivendor/features/home/widgets/bad_weather_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/enjoy_off_banner_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/filter_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/refer_banner_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/theme1/banner_view_widget1.dart';
import 'package:stackfood_multivendor/features/home/widgets/theme1/best_reviewed_item_widget1.dart';
import 'package:stackfood_multivendor/features/home/widgets/theme1/category_widget1.dart';
import 'package:stackfood_multivendor/features/home/widgets/theme1/cuisine_widget1.dart';
import 'package:stackfood_multivendor/features/home/widgets/theme1/item_campaign_widget1.dart';
import 'package:stackfood_multivendor/features/home/widgets/theme1/near_by_button_widget1.dart';
import 'package:stackfood_multivendor/features/home/widgets/theme1/popular_item_widget1.dart';
import 'package:stackfood_multivendor/features/home/widgets/theme1/popular_store_widget1.dart';
import 'package:stackfood_multivendor/features/notification/controllers/notification_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/paginated_list_view_widget.dart';

class Theme1HomeScreen extends StatelessWidget {
  final ScrollController scrollController;
  const Theme1HomeScreen({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    ConfigModel configModel = Get.find<SplashController>().configModel!;
    bool isLogin = Get.find<AuthController>().isLoggedIn();

    return CustomScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [

        // App Bar
        SliverAppBar(
          floating: true, elevation: 0, automaticallyImplyLeading: false,
          backgroundColor: ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).colorScheme.background,
          title: Center(child: Container(
            width: Dimensions.webMaxWidth, height: 50, color: Theme.of(context).colorScheme.background,
            child: Row(children: [
              Expanded(child: InkWell(
                onTap: () => Get.toNamed(RouteHelper.getAccessLocationRoute('home')),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeSmall,
                    horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0,
                  ),
                  child: GetBuilder<LocationController>(builder: (locationController) {
                    return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          AddressHelper.getAddressFromSharedPref()!.addressType == 'home' ? Icons.home_filled
                              : AddressHelper.getAddressFromSharedPref()!.addressType == 'office' ? Icons.work : Icons.location_on,
                          size: 20, color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            AddressHelper.getAddressFromSharedPref()!.address!,
                            style: robotoRegular.copyWith(
                              color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeSmall,
                            ),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: Theme.of(context).textTheme.bodyLarge!.color),
                      ],
                    );
                  }),
                ),
              )),
              InkWell(
                child: GetBuilder<NotificationController>(builder: (notificationController) {
                  return Stack(children: [
                    Icon(Icons.notifications, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),
                    notificationController.hasNotification ? Positioned(top: 0, right: 0, child: Container(
                      height: 10, width: 10, decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor, shape: BoxShape.circle,
                      border: Border.all(width: 1, color: Theme.of(context).cardColor),
                    ),
                    )) : const SizedBox(),
                  ]);
                }),
                onTap: () => Get.toNamed(RouteHelper.getNotificationRoute()),
              ),
            ]),
          )),
          actions: const [SizedBox()],
        ),

        // Search Button
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverDelegate(child: Center(child: Container(
            height: 50, width: Dimensions.webMaxWidth,
            color: Theme.of(context).colorScheme.background,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: InkWell(
              onTap: () => Get.toNamed(RouteHelper.getSearchRoute()),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
                ),
                child: Row(children: [
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Icon(
                    Icons.search, size: 25,
                    color: Theme.of(context).hintColor,
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Expanded(child: Text(
                    'search_food_or_restaurant'.tr,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor,
                    ),
                  )),
                ]),
              ),
            ),
          ))),
        ),

        SliverToBoxAdapter(
          child: Center(child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              const BannerViewWidget1(),
              const BadWeatherWidget(),
              const CategoryWidget1(),
              const ItemCampaignWidget1(),
              isLogin ? const PopularStoreWidget1(isOrderAgainViewed: true, isPopular: false) : const SizedBox(),
              configModel.mostReviewedFoods == 1 ? const BestReviewedItemWidget1() : const SizedBox(),
              const ReferBannerViewWidget(fromTheme1: true),
              isLogin ? const PopularStoreWidget1(isPopular: false, isRecentlyViewed: true) : const SizedBox(),
              const CuisinesWidget1(),
              configModel.popularRestaurant == 1 ? const PopularStoreWidget1(isPopular: true) : const SizedBox(),
              const NearByButtonWidget1(),
              configModel.popularFood == 1 ? const PopularItemWidget1(isPopular: true) : const SizedBox(),
              configModel.newRestaurant == 1 ? const PopularStoreWidget1(isPopular: false) : const SizedBox(),

              const PromotionalBannerViewWidget(),

              Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 0, 5),
                child: Row(children: [
                  Expanded(child: Text(
                    'all_restaurants'.tr,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                  )),
                  const FilterViewWidget(),
                ]),
              ),

              GetBuilder<RestaurantController>(builder: (restaurantController) {
                return PaginatedListViewWidget(
                  scrollController: scrollController,
                  totalSize: restaurantController.restaurantModel?.totalSize,
                  offset: restaurantController.restaurantModel?.offset,
                  onPaginate: (int? offset) async => await restaurantController.getRestaurantList(offset!, false),
                  productView: ProductViewWidget(
                    isRestaurant: true, products: null, showTheme1Restaurant: true,
                    restaurants: restaurantController.restaurantModel?.restaurants,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall,
                      vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0,
                    ),
                  ),
                );
              }),

            ]),
          )),
        ),
      ],
    );
  }
}
