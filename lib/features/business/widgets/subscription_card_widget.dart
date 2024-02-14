import 'package:stackfood_multivendor/features/business/domain/models/package_model.dart';
import 'package:stackfood_multivendor/features/business/widgets/curve_clipper_widget.dart';
import 'package:stackfood_multivendor/features/business/widgets/package_widget.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionCardWidget extends StatelessWidget {
  final int index;
  final Packages package;
  final Color color;
  const SubscriptionCardWidget({super.key, required this.index, required this.package, required this.color});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(children: [

      ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusLarge), topRight: Radius.circular(Dimensions.radiusLarge)),
        child: Stack(
          children: [

            ClipPath(
              clipper: CurveClipper(),
              child: Container(
              color: color.withOpacity(0.3),
              height: 140.0,
              ),
            ),

            ClipPath(
              clipper: CurveClipper(),
              child: Container(
                color: color.withOpacity(0.2),
                height: 160.0,
              ),
            ),

            ClipPath(
              clipper: CurveClipper(),
              child: Stack(
                children: [
                  SizedBox(
                    height: 120, width: size.width,
                    child: Container(
                      color: color.withOpacity(1),
                      height: 120.0,
                    ),
                  ),
                  Positioned(
                    child: SizedBox(
                      height: 120, width: size.width,
                      child: CustomPaint(
                        painter: const CardPaint(color: Colors.white),
                        child: Center(
                          child: Text(
                            '${package.packageName}',
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).cardColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ]),
      ),

      const SizedBox(height: Dimensions.paddingSizeDefault),

      Text(
        PriceConverter.convertPrice(package.price),
        style: robotoBold.copyWith(fontSize: 35, color: color),
      ),

      Text('${package.validity} ' 'days'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
      const SizedBox(height: Dimensions.paddingSizeDefault),

      Divider(color: color, indent: 70, endIndent: 70, thickness: 2),
      const SizedBox(height: Dimensions.paddingSizeDefault),

      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        PackageWidget(title: '${'max_order'.tr} (${package.maxOrder})'),

        PackageWidget(title: '${'max_product'.tr} (${package.maxProduct})'),

        package.pos != 0 ? PackageWidget(title: 'pos'.tr) : const SizedBox(),

        package.mobileApp != 0 ? PackageWidget(title: 'mobile_app'.tr) : const SizedBox(),

        package.chat != 0 ? PackageWidget(title: 'chat'.tr) : const SizedBox(),

        package.review != 0 ? PackageWidget(title: 'review'.tr) : const SizedBox(),

        package.selfDelivery != 0 ? PackageWidget(title: 'self_delivery'.tr) : const SizedBox(),
      ]),

    ]);
  }
}