import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_details_model.dart';
import 'package:stackfood_multivendor/features/product/domain/models/review_body_model.dart';
import 'package:stackfood_multivendor/features/review/controllers/review_controller.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/my_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductReviewWidget extends StatefulWidget {
  final List<OrderDetailsModel> orderDetailsList;
  const ProductReviewWidget({super.key, required this.orderDetailsList});

  @override
  State<ProductReviewWidget> createState() => _ProductReviewWidgetState();
}

class _ProductReviewWidgetState extends State<ProductReviewWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewController>(builder: (reviewController) {
      return Scrollbar(child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(child: SizedBox(width: Dimensions.webMaxWidth, child: ListView.builder(
          itemCount: widget.orderDetailsList.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 1))],
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
              ),
              child: Column(children: [

                // Product details
                Row(
                  children: [
                    (widget.orderDetailsList[index].foodDetails!.image != null && widget.orderDetailsList[index].foodDetails!.image!.isNotEmpty) ?
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImageWidget(
                        height: 70, width: 85, fit: BoxFit.cover,
                        image: '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}'
                            '/${widget.orderDetailsList[index].foodDetails!.image}',
                      ),
                    ) : const SizedBox(),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.orderDetailsList[index].foodDetails!.name!, style: robotoMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 10),

                        Text(PriceConverter.convertPrice(widget.orderDetailsList[index].foodDetails!.price), style: robotoBold),
                      ],
                    )),
                    Row(children: [
                      Text(
                        '${'quantity'.tr}: ',
                        style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.orderDetailsList[index].quantity.toString(),
                        style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]),
                  ],
                ),
                const Divider(height: 20),

                // Rate
                Text(
                  'rate_the_food'.tr,
                  style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    itemCount: 5,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) {
                      return InkWell(
                        child: Icon(
                          reviewController.ratingList[index] < (i + 1) ? Icons.star_border : Icons.star,
                          size: 25,
                          color: reviewController.ratingList[index] < (i + 1) ? Theme.of(context).disabledColor
                              : Theme.of(context).primaryColor,
                        ),
                        onTap: () {
                          if(!reviewController.submitList[index]) {
                            reviewController.setRating(index, i + 1);
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                Text(
                  'share_your_opinion'.tr,
                  style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                MyTextFieldWidget(
                  maxLines: 3,
                  capitalization: TextCapitalization.sentences,
                  isEnabled: !reviewController.submitList[index],
                  hintText: 'write_your_review_here'.tr,
                  fillColor: Theme.of(context).disabledColor.withOpacity(0.05),
                  onChanged: (text) => reviewController.setReview(index, text),
                ),
                const SizedBox(height: 20),

                // Submit button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                  child: !reviewController.loadingList[index] ? CustomButtonWidget(
                    buttonText: reviewController.submitList[index] ? 'submitted'.tr : 'submit'.tr,
                    onPressed: reviewController.submitList[index] ? null : () {
                      if(!reviewController.submitList[index]) {
                        if (reviewController.ratingList[index] == 0) {
                          showCustomSnackBar('give_a_rating'.tr);
                        } else if (reviewController.reviewList[index].isEmpty) {
                          showCustomSnackBar('write_a_review'.tr);
                        } else {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          ReviewBodyModel reviewBody = ReviewBodyModel(
                            productId: widget.orderDetailsList[index].foodDetails!.id.toString(),
                            rating: reviewController.ratingList[index].toString(),
                            comment: reviewController.reviewList[index],
                            orderId: widget.orderDetailsList[index].orderId.toString(),
                          );
                          reviewController.submitReview(index, reviewBody).then((value) {
                            if (value.isSuccess) {
                              showCustomSnackBar(value.message, isError: false);
                              reviewController.setReview(index, '');
                            } else {
                              showCustomSnackBar(value.message);
                            }
                          });
                        }
                      }
                    },
                  ) : const Center(child: CircularProgressIndicator()),
                ),

              ]),
            );
          },
        ))),
      ));
    });
  }
}
