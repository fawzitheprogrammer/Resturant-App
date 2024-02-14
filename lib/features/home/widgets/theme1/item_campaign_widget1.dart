import 'package:stackfood_multivendor/features/product/controllers/campaign_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/common/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

class ItemCampaignWidget1 extends StatelessWidget {
  const ItemCampaignWidget1({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CampaignController>(builder: (campaignController) {
      return (campaignController.itemCampaignList != null && campaignController.itemCampaignList!.isEmpty) ? const SizedBox() : Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: TitleWidget(title: 'trending_food_offers'.tr, onTap: () => Get.toNamed(RouteHelper.getItemCampaignRoute())),
          ),

          SizedBox(
            height: 150,
            child: campaignController.itemCampaignList != null ? ListView.builder(
              controller: ScrollController(),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
              itemCount: campaignController.itemCampaignList!.length > 10 ? 10 : campaignController.itemCampaignList!.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: 5),
                  child: InkWell(
                    onTap: () {
                      ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
                        ProductBottomSheetWidget(product: campaignController.itemCampaignList![index], isCampaign: true),
                        backgroundColor: Colors.transparent, isScrollControlled: true,
                      ) : Get.dialog(
                        Dialog(child: ProductBottomSheetWidget(product: campaignController.itemCampaignList![index], isCampaign: true)),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImageWidget(
                        image: '${Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl}'
                            '/${campaignController.itemCampaignList![index].image}',
                        height: 150, width: 150, fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ) : ItemCampaignShimmer(campaignController: campaignController),
          ),
        ],
      );
    });
  }
}

class ItemCampaignShimmer extends StatelessWidget {
  final CampaignController campaignController;
  const ItemCampaignShimmer({super.key, required this.campaignController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      itemCount: 10,
      itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: 5),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: campaignController.itemCampaignList == null,
            child: Container(
              height: 150, width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: Colors.grey[300],
              ),
            ),
          ),
        );
      },
    );
  }
}

