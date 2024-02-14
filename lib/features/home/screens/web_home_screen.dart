import 'package:stackfood_multivendor/features/home/controllers/home_controller.dart';
import 'package:stackfood_multivendor/features/home/widgets/all_restaurant_filter_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/all_restaurants_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/bad_weather_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/best_review_item_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/enjoy_off_banner_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/order_again_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/popular_foods_nearby_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/popular_restaurants_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/today_trends_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/web/web_banner_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/web/web_cuisine_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/web/web_loaction_and_refer_banner_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/web/web_new_on_stackfood_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/what_on_your_mind_view_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebHomeScreen extends StatefulWidget {
  final ScrollController scrollController;
  const WebHomeScreen({super.key, required this.scrollController});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  ConfigModel? _configModel;

  @override
  void initState() {
    super.initState();
    Get.find<HomeController>().setCurrentIndex(0, false);
    _configModel = Get.find<SplashController>().configModel;
  }

  @override
  Widget build(BuildContext context) {

    bool isLogin = Get.find<AuthController>().isLoggedIn();

    return CustomScrollView(
      controller: widget.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [

        const SliverToBoxAdapter(
          child: Center(child: SizedBox(width: Dimensions.webMaxWidth,
              child: WhatOnYourMindViewWidget()),
          ),
        ),

        SliverToBoxAdapter(child: GetBuilder<HomeController>(builder: (bannerController) {
          return bannerController.bannerImageList == null ? WebBannerViewWidget(homeController: bannerController)
              : bannerController.bannerImageList!.isEmpty ? const SizedBox() : WebBannerViewWidget(homeController: bannerController);
        })),


        SliverToBoxAdapter(
            child: Center(child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: Column(children: [

                const BadWeatherWidget(),

                const TodayTrendsViewWidget(),

                isLogin ? const OrderAgainViewWidget() : const SizedBox(),

                _configModel!.popularFood == 1 ?  const BestReviewItemViewWidget(isPopular: false) : const SizedBox(),

                const WebCuisineViewWidget(),

                const PopularRestaurantsViewWidget(),

                const PopularFoodNearbyViewWidget(),

                isLogin ? const PopularRestaurantsViewWidget(isRecentlyViewed: true) : const SizedBox(),

                const WebLocationAndReferBannerViewWidget(),

                _configModel!.newRestaurant == 1 ? const WebNewOnStackFoodViewWidget(isLatest: true) : const SizedBox(),

                const PromotionalBannerViewWidget(),

                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              ]),
            ))
        ),


        SliverPersistentHeader(
          pinned: true,
          delegate: SliverDelegate(
            child: const AllRestaurantFilterWidget(),
          ),
        ),



        SliverToBoxAdapter(child: Center(child: Column(
          children: [
            const SizedBox(height: Dimensions.paddingSizeLarge),

            FooterViewWidget(
              child: AllRestaurantsWidget(scrollController: widget.scrollController),
            ),
          ],
        ))),

      ],
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }
}
