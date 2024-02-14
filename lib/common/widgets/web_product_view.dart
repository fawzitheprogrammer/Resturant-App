import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_product_widget.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/web_restaurant_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebProductView extends StatelessWidget {
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
  const WebProductView({super.key, required this.restaurants, required this.products, required this.isRestaurant, this.isScrollable = false,
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
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: Dimensions.paddingSizeLarge,
          mainAxisSpacing:  Dimensions.paddingSizeLarge,
          childAspectRatio: 0.9,
          crossAxisCount: 4,
        ),
        physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
        shrinkWrap: isScrollable ? false : true,
        itemCount: length,
        padding: padding,
        itemBuilder: (context, index) {
          return WebProductWidget(
            isRestaurant: false, product: products![index], isFeatured: false,
            restaurant:  null, index: index, length: length, isCampaign: false,
            inRestaurant: inRestaurantPage,
          );
        },

      ) : NoDataScreen(
        title: noDataText ?? (isRestaurant ? 'no_restaurant_available'.tr : 'no_food_available'.tr),
      ) : GridView.builder(
        key: UniqueKey(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: Dimensions.paddingSizeLarge,
          mainAxisSpacing:  Dimensions.paddingSizeLarge,
          childAspectRatio: 0.8,
          crossAxisCount: 4,
        ),
        physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
        shrinkWrap: isScrollable ? false : true,
        itemCount: shimmerLength,
        padding: padding,
        itemBuilder: (context, index) {
          return const WebRestaurantShimmer();
        },
      ),

    ]);
  }
}
