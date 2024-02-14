import 'package:carousel_slider/carousel_slider.dart';
import 'package:stackfood_multivendor/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CouponViewWidget extends StatelessWidget {
  final double scrollingRate;
  const CouponViewWidget({super.key, required this.scrollingRate});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return GetBuilder<CouponController>(
        builder: (couponController) {
          return couponController.couponList!= null && couponController.couponList!.isNotEmpty ? Column(children: [
            SizedBox(
              height: isDesktop ? 110 - (scrollingRate *  20) : 85 - (scrollingRate * 60),
              width: double.infinity,
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  disableCenter: true,
                  viewportFraction: 1,
                  autoPlayInterval: const Duration(seconds: 7),
                  onPageChanged: (index, reason) {
                    couponController.setCurrentIndex(index, true);
                  },
                ),
                itemCount: couponController.couponList!.length,
                itemBuilder: (context, index, _) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                      color: Theme.of(context).primaryColor.withOpacity(0.07),
                    ),
                    padding: EdgeInsets.all(Dimensions.paddingSizeSmall - (scrollingRate * (isDesktop ? 2 : Dimensions.paddingSizeSmall))),
                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                    child: Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                        Row(children: [
                          Flexible(
                            child: Text(
                              '"${couponController.couponList![index].title!}"', maxLines: 1,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault - (scrollingRate * (isDesktop ? 2 : Dimensions.fontSizeDefault)), overflow: TextOverflow.ellipsis, color: Theme.of(context).textTheme.bodyLarge!.color),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: couponController.couponList![index].code!));
                              showCustomSnackBar('coupon_code_copied'.tr, isError: false);
                            },
                            child: Icon(Icons.copy_rounded, size: 16 - (scrollingRate * (isDesktop ? 2 : 16)), color: Theme.of(context).primaryColor),
                          ),
                        ]),
                        SizedBox(height: Dimensions.paddingSizeExtraSmall - (scrollingRate * (isDesktop ? 2 : Dimensions.paddingSizeExtraSmall))),

                        Text(
                          '${DateConverter.stringToReadableString(couponController.couponList![index].startDate!)} ${'to'.tr} ${DateConverter.stringToReadableString(couponController.couponList![index].expireDate!)}',
                          style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * (isDesktop ? 2 : Dimensions.fontSizeExtraSmall))),
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                        ),

                        Row(children: [
                          Text(
                            '${'min_purchase'.tr} ',
                            style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall - (scrollingRate * (isDesktop ? 2 : Dimensions.fontSizeSmall))),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: Dimensions.paddingSizeExtraSmall - (scrollingRate * (isDesktop ? 2 : Dimensions.paddingSizeExtraSmall))),

                          Text(
                            PriceConverter.convertPrice(couponController.couponList![index].minPurchase),
                            style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall - (scrollingRate * (isDesktop ? 2 : Dimensions.fontSizeSmall))),
                            maxLines: 1, overflow: TextOverflow.ellipsis, textDirection: TextDirection.ltr,
                          ),
                        ]),
                      ])),

                      Image.asset(Images.restaurantCoupon, height: 55 - (scrollingRate * (isDesktop ? 2 : 55)), width: 55),
                    ]),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: couponController.couponList!.map((bnr) {
                int index = couponController.couponList!.indexOf(bnr);
                return TabPageSelectorIndicator(
                  backgroundColor: index == couponController.currentIndex ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor.withOpacity(0.5),
                  borderColor: Theme.of(context).colorScheme.background,
                  size: index == couponController.currentIndex ? 7 - (scrollingRate * (isDesktop ? 2 : 7)) : 5 - (scrollingRate * (isDesktop ? 2 : 5)),
                );
              }).toList(),
            ),
          ]) : const SizedBox();
        }
    );
  }
}
