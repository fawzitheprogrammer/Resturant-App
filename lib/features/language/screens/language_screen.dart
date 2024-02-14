import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/language/widgets/language_widget.dart';
import 'package:stackfood_multivendor/features/language/widgets/save_button_widget.dart';
import 'package:stackfood_multivendor/features/language/widgets/web_language_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:get/get.dart';

class ChooseLanguageScreen extends StatefulWidget {
  final bool fromMenu;
  const ChooseLanguageScreen({super.key, this.fromMenu = false});

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.fromMenu || ResponsiveHelper.isDesktop(context)) ? CustomAppBarWidget(title: 'language'.tr, isBackButtonExist: true) : null,
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: GetBuilder<LocalizationController>(builder: (localizationController) {
          return Column(children: [
            WebScreenTitleWidget(title: 'language'.tr),

            Expanded(child: Center(
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage(Images.languageBackground),)
                ),
                child: Scrollbar(
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeSmall),
                    child: FooterViewWidget(
                      child: Center(child: SizedBox(
                        width: Dimensions.webMaxWidth,
                        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

                          !ResponsiveHelper.isDesktop(context) ? Column(children: [
                            Center(child: Image.asset(Images.logo, width: 60)),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Center(child: Image.asset(Images.logoName, width: 100)),
                          ]) : const SizedBox(),

                          const SizedBox(height: 30),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                            child: Text('select_language'.tr, style: robotoMedium),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: ResponsiveHelper.isDesktop(context) ? 2 : ResponsiveHelper.isTab(context) ? 3 : 2,
                                childAspectRatio: ResponsiveHelper.isDesktop(context) ? 6 : (1/1),
                                mainAxisSpacing: Dimensions.paddingSizeDefault,
                                crossAxisSpacing: Dimensions.paddingSizeDefault,
                              ),
                              itemCount: localizationController.languages.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              itemBuilder: (context, index) => ResponsiveHelper.isDesktop(context) ? WebLanguageWidget(
                                languageModel: localizationController.languages[index],
                                localizationController: localizationController, index: index,
                              ) : LanguageWidget(
                                languageModel: localizationController.languages[index],
                                localizationController: localizationController, index: index,
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          // ResponsiveHelper.isDesktop(context) ? LanguageSaveButton(localizationController: localizationController, fromMenu: widget.fromMenu) : const SizedBox(),

                        ]),
                      )),
                    ),
                  ),
                ),
              ),
            )),

            ResponsiveHelper.isDesktop(context) ? const SizedBox.shrink() : SaveButtonWidget(localizationController: localizationController, fromMenu: widget.fromMenu),

          ]);
        }),
      ),
    );
  }
}
