import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/item_card_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/review/controllers/review_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BestReviewItemViewWidget extends StatelessWidget {
  final bool isPopular;
  const BestReviewItemViewWidget({super.key, required this.isPopular});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewController>(builder: (reviewController) {
        return (reviewController.reviewedProductList !=null && reviewController.reviewedProductList!.isEmpty) ? const SizedBox() : Padding(
          padding:  EdgeInsets.symmetric(vertical: ResponsiveHelper.isMobile(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge),
          child: SizedBox(
            height: ResponsiveHelper.isMobile(context) ? 300 : 315, width: Dimensions.webMaxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
                  child: Row(children: [
                      Text('best_review_item'.tr, style: robotoMedium.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),

                      const Spacer(),

                      ArrowIconButtonWidget(
                        onTap: () => Get.toNamed(RouteHelper.getPopularFoodRoute(isPopular)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),


              reviewController.reviewedProductList !=null ? Expanded(
                  child: SizedBox(
                    height: ResponsiveHelper.isMobile(context) ? 240 : 255,
                    child: ListView.builder(
                      itemCount: reviewController.reviewedProductList!.length,
                      padding: EdgeInsets.only(right: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: (ResponsiveHelper.isDesktop(context) && index == 0 && Get.find<LocalizationController>().isLtr) ? 0 : Dimensions.paddingSizeDefault),
                          child: ItemCardWidget(
                            isBestItem: true, product: reviewController.reviewedProductList![index],
                          ),
                        );
                      },
                    ),
                  ),
                ) : const ItemCardShimmer(isPopularNearbyItem: false),
              ],
            ),

          ),
        );
      }
    );
  }
}
