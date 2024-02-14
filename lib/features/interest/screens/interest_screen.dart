import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/interest/controllers/interest_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InterestScreen extends StatefulWidget {
  const InterestScreen({super.key});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<InterestController>().getCategoryList(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: GetBuilder<InterestController>(builder: (interestController) {
          return interestController.categoryList != null ? interestController.categoryList!.isNotEmpty ? Center(
            child: Container(
              width: Dimensions.webMaxWidth,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('choose_your_interests'.tr, style: robotoMedium.copyWith(fontSize: 22)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text('get_personalized_recommendations'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: interestController.categoryList!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 3 : 2,
                      childAspectRatio: (1/0.35),
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => interestController.addInterestSelection(index),
                        child: Container(
                          margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall,
                          ),
                          decoration: BoxDecoration(
                            color: interestController.interestCategorySelectedList![index] ? Theme.of(context).primaryColor
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
                          ),
                          alignment: Alignment.center,
                          child: Row(children: [
                            CustomImageWidget(
                              image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}'
                                  '/${interestController.categoryList![index].image}',
                              height: 30, width: 30,
                            ),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            Flexible(child: Text(
                              interestController.categoryList![index].name!,
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: interestController.interestCategorySelectedList![index] ? Theme.of(context).cardColor
                                    : Theme.of(context).textTheme.bodyLarge!.color,
                              ),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            )),
                          ]),
                        ),
                      );
                    },
                  ),
                ),

                CustomButtonWidget(
                  buttonText: 'save_and_continue'.tr,
                  isLoading: interestController.isLoading,
                  onPressed: () {
                    List<int?> interests = [];
                    for(int index=0; index<interestController.categoryList!.length; index++) {
                      if(interestController.interestCategorySelectedList![index]) {
                        interests.add(interestController.categoryList![index].id);
                      }
                    }
                    interestController.saveInterest(interests).then((isSuccess) {
                      if(isSuccess) {
                        Get.offAllNamed(RouteHelper.getInitialRoute());
                      }
                    });
                  },
                ),

              ]),
            ),
          ) : NoDataScreen(title: 'no_category_found'.tr) : const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
