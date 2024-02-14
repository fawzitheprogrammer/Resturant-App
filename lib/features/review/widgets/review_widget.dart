import 'package:stackfood_multivendor/common/models/review_model.dart';
import 'package:stackfood_multivendor/common/widgets/rating_bar_widget.dart';
import 'package:stackfood_multivendor/features/review/widgets/review_dialog_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;
  final bool hasDivider;
  const ReviewWidget({super.key, required this.review, required this.hasDivider});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.dialog(ReviewDialogWidget(review: review)),
      child: Column(children: [

        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

          ClipOval(
            child: CustomImageWidget(
              image: '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/${review.foodImage ?? ''}',
              height: 60, width: 60, fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(
              review.foodName!, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),

            RatingBarWidget(rating: review.rating!.toDouble(), ratingCount: null, size: 15),

            Text(
              review.customerName ?? '',
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
            ),

            Text(
              review.comment!, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
            ),

          ])),

        ]),

        (hasDivider && ResponsiveHelper.isMobile(context)) ? Padding(
          padding: const EdgeInsets.only(left: 70),
          child: Divider(color: Theme.of(context).disabledColor),
        ) : const SizedBox(),

      ]),
    );
  }
}
