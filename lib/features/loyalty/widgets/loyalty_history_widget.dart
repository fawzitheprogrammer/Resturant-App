import 'package:stackfood_multivendor/features/loyalty/controllers/loyalty_controller.dart';
import 'package:stackfood_multivendor/features/loyalty/widgets/loyalty_history_card_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class LoyaltyHistoryWidget extends StatelessWidget {
  const LoyaltyHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoyaltyController>(
      builder: (walletController) {

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'point_history'.tr,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),

          walletController.transactionList != null ? walletController.transactionList!.isNotEmpty ? GridView.builder(
            key: UniqueKey(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 50,
              mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0.01,
              childAspectRatio: ResponsiveHelper.isDesktop(context) ? 7 : 4.45,
              crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 1,
            ),
            physics:  const NeverScrollableScrollPhysics(),
            shrinkWrap:  true,
            itemCount: walletController.transactionList!.length ,
            padding: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 28 : 25),
            itemBuilder: (context, index) {
              return LoyaltyHistoryCardWidget(index: index, data: walletController.transactionList);
            },
          ) : NoDataScreen(title: 'no_data_found'.tr) : LoyaltyShimmer(loyaltyController: walletController),

          walletController.isLoading ? const Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: CircularProgressIndicator(),
          )) : const SizedBox(),


        ]);
      }
    );
  }
}


class LoyaltyShimmer extends StatelessWidget {
  final LoyaltyController loyaltyController;
  const LoyaltyShimmer({super.key, required this.loyaltyController});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: UniqueKey(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 50,
        mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0.01,
        childAspectRatio: ResponsiveHelper.isDesktop(context) ? 5 : 4.1,
        crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 1,
      ),
      physics:  const NeverScrollableScrollPhysics(),
      shrinkWrap:  true,
      itemCount: 10,
      padding: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 28 : 25),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: loyaltyController.transactionList == null,
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(height: 10, width: 50, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 10),
                    Container(height: 10, width: 70, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                  ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Container(height: 10, width: 50, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 10),
                    Container(height: 10, width: 70, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                  ]),
                ],
              ),
              Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge), child: Divider(color: Theme.of(context).disabledColor)),
            ],
            ),
          ),
        );
      },
    );
  }
}