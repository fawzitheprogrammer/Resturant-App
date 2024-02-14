import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<CategoryController>().getCategoryList(false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'categories'.tr),
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: Scrollbar(controller: scrollController, child: SingleChildScrollView(
          controller: scrollController, child: FooterViewWidget(
            child: Column(children: [
              WebScreenTitleWidget(title: 'categories'.tr),

              Center(child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: GetBuilder<CategoryController>(builder: (catController) {
                  return catController.categoryList != null ? catController.categoryList!.isNotEmpty ? GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 4 : 3,
                      childAspectRatio: (1/1),
                      mainAxisSpacing: Dimensions.paddingSizeSmall,
                      crossAxisSpacing: Dimensions.paddingSizeSmall,
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    itemCount: catController.categoryList!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Get.toNamed(RouteHelper.getCategoryProductRoute(
                          catController.categoryList![index].id, catController.categoryList![index].name!,
                        )),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
                          ),
                          alignment: Alignment.center,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                            ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              child: CustomImageWidget(
                                height: 50, width: 50, fit: BoxFit.cover,
                                image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${catController.categoryList![index].image}',
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Text(
                              catController.categoryList![index].name!, textAlign: TextAlign.center,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                              maxLines: 2, overflow: TextOverflow.ellipsis,
                            ),

                          ]),
                        ),
                      );
                    },
                  ) : NoDataScreen(title: 'no_category_found'.tr) : const Center(child: CircularProgressIndicator());
                }),
              )),
            ],
          )),
        )),
      ),
    );
  }
}
