import 'package:stackfood_multivendor/features/home/widgets/item_card_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class RestaurantScreenShimmerWidget extends StatelessWidget {
  const RestaurantScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: ResponsiveHelper.isMobile(context) ? Column(children: [

        Shimmer(
          duration: const Duration(seconds: 2),
          enabled: true,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Shimmer(
          duration: const Duration(seconds: 2),
          enabled: true,
          child: Container(
            height: 110,
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            child: Row(
              children: [
                Container(
                  height: 80, width: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeLarge),

                Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    height: 10, width: 150,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                  ),

                  Container(
                    height: 10, width: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                  ),

                  Container(
                    height: 10, width: 150,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                  ),

                ]),

                const Spacer(),

                Icon(Icons.favorite_border, size: 25, color: Theme.of(context).cardColor),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Icon(Icons.share, size: 25, color: Theme.of(context).cardColor),
              ],
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Shimmer(
          duration: const Duration(seconds: 2),
          enabled: true,
          child: Container(
            color: Colors.grey[300],
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
            child: Column(children: [

              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

                Column(children: [
                  Icon(Icons.star, color: Theme.of(context).cardColor),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Container(
                    height: 10, width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                  ),
                ]),

                Column(children: [
                  Icon(Icons.location_on, color: Theme.of(context).cardColor),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Container(
                    height: 10, width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                  ),
                ]),

                Column(children: [
                  Icon(Icons.timer_rounded, color: Theme.of(context).cardColor),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Container(
                    height: 10, width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                  ),
                ]),
              ]),
            ]),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              child: Shimmer(
                duration: const Duration(seconds: 2),
                enabled: true,
                child: Container(
                  height: 90,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 70, width: 70,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                      ),

                      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Container(
                          height: 10, width: 200,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                        ),

                        Container(
                          height: 10, width: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                        ),

                        Container(
                          height: 10, width: 200,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                        ),

                      ]),

                      Icon(Icons.favorite_border, size: 25, color: Theme.of(context).cardColor),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ]) : Column(children: [

        Shimmer(
          duration: const Duration(seconds: 2),
          enabled: true,
          child: Center(
            child: SizedBox(
              height: 320,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 250, width: Dimensions.webMaxWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.radiusLarge), bottomRight: Radius.circular(Dimensions.radiusLarge)),
                    ),
                  ),
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                      height: 150, width: Dimensions.webMaxWidth,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                    ),
                      child: Row(children: [

                        Container(
                          height: 120, width: 120,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 100),

                        Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                            height: 10, width: 150,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                          ),

                          Container(
                            height: 10, width: 100,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                          ),

                          Container(
                            height: 10, width: 150,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                          ),

                          Row(children: [

                            Column(children: [
                              Icon(Icons.star, color: Theme.of(context).cardColor),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              Container(
                                height: 10, width: 100,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                ),
                              ),
                            ]),
                            const SizedBox(width: Dimensions.paddingSizeLarge),

                            Column(children: [
                              Icon(Icons.location_on, color: Theme.of(context).cardColor),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              Container(
                                height: 10, width: 100,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                ),
                              ),
                            ]),
                            const SizedBox(width: Dimensions.paddingSizeLarge),

                            Column(children: [
                              Icon(Icons.timer_rounded, color: Theme.of(context).cardColor),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              Container(
                                height: 10, width: 100,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                ),
                              ),
                            ]),
                          ]),

                        ]),

                        const Spacer(),

                        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.favorite_border, size: 25, color: Theme.of(context).cardColor),
                          const SizedBox(width: Dimensions.paddingSizeDefault),
                          Icon(Icons.share, size: 25, color: Theme.of(context).cardColor),
                        ]),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        Container(
                          height: 100, width: 300,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Shimmer(
          duration: const Duration(seconds: 2),
          enabled: true,
          child: Center(
            child: Container(
              width: Dimensions.webMaxWidth,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
              child: Stack(children: [

                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                    child: Container(
                      height: 20, width: 200,
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                    child: Container(
                      height: 15, width: 150,
                      color: Theme.of(context).cardColor,
                    ),
                  ),

                  SizedBox(
                    height: 270, width: Get.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
                          child: ItemCardShimmer(isPopularNearbyItem: false),
                        );
                      },
                    ),
                  ),
                ]),
              ]),
            ),
          ),
        ),

        Shimmer(
          duration: const Duration(seconds: 2),
          enabled: true,
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              width: Dimensions.webMaxWidth, height: 150,
              color: Colors.grey[300],
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Row(children: [
                  Container(
                    height: 20, width: 200,
                    color: Theme.of(context).cardColor,
                  ),
                  const Spacer(),

                  Container(
                    height: 35, width: 300,
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                    ),
                    child: Row(children: [
                      Icon(Icons.search, size: 20, color: Colors.grey[300]),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: Text('search_for_products'.tr, style: robotoRegular.copyWith(color: Colors.grey[300])),
                      ),
                    ]),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(children: [

                  Container(
                    height: 30, width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Container(
                    height: 30, width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Container(
                    height: 30, width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Container(
                    height: 30, width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                    ),
                  ),

                ]),

              ]),
            ),
          ),
        ),

      ]),
    );
  }
}