import 'package:stackfood_multivendor/features/product/controllers/campaign_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemCampaignScreen extends StatefulWidget {
  const ItemCampaignScreen({super.key});

  @override
  State<ItemCampaignScreen> createState() => _ItemCampaignScreenState();
}

class _ItemCampaignScreenState extends State<ItemCampaignScreen> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<CampaignController>().getItemCampaignList(false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'trending_food_offers'.tr),
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body: Scrollbar(controller: scrollController, child: SingleChildScrollView(controller: scrollController, child: Center(child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: GetBuilder<CampaignController>(builder: (campController) {
          return ProductViewWidget(
            isRestaurant: false, products: campController.itemCampaignList, restaurants: null,
            isCampaign: true, noDataText: 'no_campaign_found'.tr,
          );
        }),
      )))),
    );
  }

}
