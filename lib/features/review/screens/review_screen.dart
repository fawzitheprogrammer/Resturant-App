import 'package:stackfood_multivendor/features/review/controllers/review_controller.dart';
import 'package:stackfood_multivendor/features/review/widgets/review_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewScreen extends StatefulWidget {
  final String? restaurantID;
  const ReviewScreen({super.key, required this.restaurantID});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<ReviewController>().getRestaurantReviewList(widget.restaurantID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'restaurant_reviews'.tr),
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<ReviewController>(builder: (restController) {
        return restController.restaurantReviewList != null ? restController.restaurantReviewList!.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await restController.getRestaurantReviewList(widget.restaurantID);
          },
          child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: FooterViewWidget(
                child: Center(child: SizedBox(width: Dimensions.webMaxWidth, child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                    childAspectRatio: (1/0.205), crossAxisSpacing: 10, mainAxisSpacing: 10,
                  ),
                  itemCount: restController.restaurantReviewList!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  itemBuilder: (context, index) {
                    return ReviewWidget(
                      review: restController.restaurantReviewList![index],
                      hasDivider: index != restController.restaurantReviewList!.length-1,
                    );
                  },
                ))),
              )),
        ) : Center(child: NoDataScreen(title: 'no_review_found'.tr)) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
