import 'package:stackfood_multivendor/features/product/controllers/campaign_controller.dart';
import 'package:stackfood_multivendor/features/product/domain/models/basic_campaign_model.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignScreen extends StatefulWidget {
  final BasicCampaignModel campaign;
  const CampaignScreen({super.key, required this.campaign});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<CampaignController>().getBasicCampaignDetails(widget.campaign.id);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<CampaignController>(builder: (campaignController) {
        return CustomScrollView(
          controller: _scrollController,
          slivers: [

            ResponsiveHelper.isDesktop(context) ? SliverToBoxAdapter(
              child: Container(
                color: const Color(0xFF171A29),
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImageWidget(
                    fit: BoxFit.cover, height: 220, width: 1150, placeholder: Images.restaurantCover,
                    image: '${Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl}/${widget.campaign.image}',
                  ),
                ),
              ),
            ) : SliverAppBar(
              expandedHeight: 230,
              toolbarHeight: 50,
              pinned: true,
              floating: false,
              backgroundColor: Theme.of(context).primaryColor,
              leading: IconButton(icon: const Icon(Icons.chevron_left, color: Colors.white), onPressed: () => Get.back()),
              flexibleSpace: FlexibleSpaceBar(
                // title: Text(
                //   widget.campaign.title!,
                //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.white),
                // ),
                background: CustomImageWidget(
                  fit: BoxFit.cover, placeholder: Images.restaurantCover,
                  image: '${Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl}/${widget.campaign.image}',
                ),
              ),
              actions: const [SizedBox()],
            ),

            SliverToBoxAdapter(child: FooterViewWidget(
              child: Center(child: Container(
                width: Dimensions.webMaxWidth,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
                ),
                child: Column(children: [

                  campaignController.campaign != null ? Column(
                    children: [

                      Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          child: CustomImageWidget(
                            image: '${Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl}/${campaignController.campaign!.image}',
                            height: 40, width: 50, fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            campaignController.campaign!.title!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            campaignController.campaign!.description ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                          ),
                        ])),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      campaignController.campaign!.startTime != null ? Row(children: [
                        Text('campaign_schedule'.tr, style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text(
                          '${DateConverter.stringToLocalDateOnly(campaignController.campaign!.availableDateStarts!)}'
                              ' - ${DateConverter.stringToLocalDateOnly(campaignController.campaign!.availableDateEnds!)}',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                        ),
                      ]) : const SizedBox(),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      campaignController.campaign!.startTime != null ? Row(children: [
                        Text('daily_time'.tr, style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text(
                          '${DateConverter.convertTimeToTime(campaignController.campaign!.startTime!)}'
                              ' - ${DateConverter.convertTimeToTime(campaignController.campaign!.endTime!)}',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                        ),
                      ]) : const SizedBox(),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    ],
                  ) : const SizedBox(),

                  ProductViewWidget(
                    isRestaurant: true, products: null,
                    restaurants: campaignController.campaign?.restaurants,
                  ),

                ]),
              )),
            )),
          ],
        );
      }),
    );
  }
}