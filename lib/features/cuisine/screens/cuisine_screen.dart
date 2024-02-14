import 'package:stackfood_multivendor/features/home/widgets/cuisine_card_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/cuisine/controllers/cuisine_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CuisineScreen extends StatefulWidget {
  const CuisineScreen({super.key});

  @override
  State<CuisineScreen> createState() => _CuisineScreenState();
}

class _CuisineScreenState extends State<CuisineScreen> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    Get.find<CuisineController>().getCuisineList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'cuisines'.tr),
      backgroundColor: Theme.of(context).colorScheme.background,
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body: Scrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              WebScreenTitleWidget(title: 'cuisines'.tr),

              Center(child: FooterViewWidget(
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: Column(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          await Get.find<CuisineController>().getCuisineList();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeDefault, right: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeDefault),
                          child: GetBuilder<CuisineController>(
                              builder: (cuisineController) {
                                return cuisineController.cuisineModel != null ? GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: ResponsiveHelper.isMobile(context) ? 4 : ResponsiveHelper.isDesktop(context) ? 8 : 6,
                                        mainAxisSpacing: Dimensions.paddingSizeDefault,
                                        crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 35 : Dimensions.paddingSizeDefault,
                                        childAspectRatio: 1
                                    ),
                                    shrinkWrap: true,
                                    itemCount: cuisineController.cuisineModel!.cuisines!.length,
                                    scrollDirection: Axis.vertical,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index){
                                      return InkWell(
                                        hoverColor: Colors.transparent,
                                        onTap: (){
                                          Get.toNamed(RouteHelper.getCuisineRestaurantRoute(cuisineController.cuisineModel!.cuisines![index].id, cuisineController.cuisineModel!.cuisines![index].name));
                                        },
                                        child: SizedBox(
                                          height: 130,
                                          child: CuisineCardWidget(
                                            image: '${Get.find<SplashController>().configModel!.baseUrls!.cuisineImageUrl}/${cuisineController.cuisineModel!.cuisines![index].image}',
                                            name: cuisineController.cuisineModel!.cuisines![index].name!,
                                          ),
                                        ),
                                      );
                                    }) : const Center(child: CircularProgressIndicator());
                              }
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
