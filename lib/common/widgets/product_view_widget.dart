import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_shimmer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/theme1/restaurant_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/web_restaurant_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductViewWidget extends StatelessWidget {
  final List<Product?>? products;
  final List<Restaurant?>? restaurants;
  final bool isRestaurant;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String? noDataText;
  final bool isCampaign;
  final bool inRestaurantPage;
  final bool showTheme1Restaurant;
  final bool? isWebRestaurant;
  const ProductViewWidget({super.key, required this.restaurants, required this.products, required this.isRestaurant, this.isScrollable = false,
    this.shimmerLength = 20, this.padding = const EdgeInsets.all(Dimensions.paddingSizeSmall), this.noDataText,
    this.isCampaign = false, this.inRestaurantPage = false, this.showTheme1Restaurant = false, this.isWebRestaurant = false});

  @override
  Widget build(BuildContext context) {
    bool isNull = true;
    int length = 0;
    if(isRestaurant) {
      isNull = restaurants == null;
      if(!isNull) {
        length = restaurants!.length;
      }
    }else {
      isNull = products == null;
      if(!isNull) {
        length = products!.length;
      }
    }

    return Column(children: [

      !isNull ? length > 0 ? GridView.builder(
        key: UniqueKey(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: Dimensions.paddingSizeLarge,
          mainAxisSpacing: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? Dimensions.paddingSizeLarge : isWebRestaurant! ? Dimensions.paddingSizeLarge : 0.01,
          //childAspectRatio: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? 3 : isWebRestaurant! ? 1.5 : showTheme1Restaurant ? 1.9 : 3.3,
          mainAxisExtent: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? 140 : isWebRestaurant! ? 280 : showTheme1Restaurant ? 200 : 122,
          crossAxisCount: ResponsiveHelper.isMobile(context) && !isWebRestaurant! ? 1 : isWebRestaurant! ? 4 : 3,
        ),
        physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
        shrinkWrap: isScrollable ? false : true,
        itemCount: length,
        padding: padding,
        itemBuilder: (context, index) {
          return showTheme1Restaurant ? RestaurantWidget(restaurant: restaurants![index], index: index, inStore: inRestaurantPage)
          : isWebRestaurant! ? WebRestaurantWidget(restaurant: restaurants![index]) : ProductWidget(
            isRestaurant: isRestaurant, product: isRestaurant ? null : products![index],
            restaurant: isRestaurant ? restaurants![index] : null, index: index, length: length, isCampaign: isCampaign,
            inRestaurant: inRestaurantPage,
          );
        },
      ) : NoDataScreen(
        isRestaurant: isRestaurant,
        title: noDataText ?? (isRestaurant ? 'no_restaurant_available'.tr : 'no_food_available'.tr),
      ) : GridView.builder(
        key: UniqueKey(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: Dimensions.paddingSizeLarge,
          mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0.01,
          //childAspectRatio: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? 3 : isWebRestaurant! ? 1.5 : showTheme1Restaurant ? 1.9 : 3.3,
          mainAxisExtent: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? 140 : isWebRestaurant! ? 280 : showTheme1Restaurant ? 250 : 122,
          crossAxisCount: ResponsiveHelper.isMobile(context) && !isWebRestaurant! ? 1 : isWebRestaurant! ? 4 : 3,
        ),
        physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
        shrinkWrap: isScrollable ? false : true,
        itemCount: shimmerLength,
        padding: padding,
        itemBuilder: (context, index) {
          return showTheme1Restaurant ? RestaurantShimmer(isEnable: isNull)
              : isWebRestaurant! ? const WebRestaurantShimmer() : ProductShimmer(isEnabled: isNull, isRestaurant: isRestaurant, hasDivider: index != shimmerLength-1);
        },
      ),

    ]);
  }
}
