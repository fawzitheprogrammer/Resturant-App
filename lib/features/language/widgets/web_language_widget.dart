import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/language/domain/models/language_model.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebLanguageWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final LocalizationController localizationController;
  final int index;
  const WebLanguageWidget({super.key, required this.languageModel, required this.localizationController, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: () {
        localizationController.setLanguage(Locale(
          AppConstants.languages[index].languageCode!,
          AppConstants.languages[index].countryCode,
        ));
        localizationController.setSelectLanguageIndex(index);
      },
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
          border: Border.all(color: localizationController.selectedLanguageIndex == index ? Theme.of(context).primaryColor : Colors.transparent)
        ),
        child: Stack(children: [
          Center(
            child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: 59, width: 59,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!, width: 1),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  languageModel.imageUrl!, width: 26, height: 26,
                  color: languageModel.languageCode == 'en' || languageModel.languageCode == 'ar' || languageModel.languageCode == 'bn'
                      ? Theme.of(context).textTheme.bodyLarge!.color : null,
                ),
              ),
              const SizedBox(width : Dimensions.paddingSizeLarge),
              Text(languageModel.languageName!, style: robotoRegular),
            ]),
          ),

          localizationController.selectedLanguageIndex == index ? Positioned(
            top: 0, right: 0,
            child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 25),
          ) : const SizedBox(),

        ]),
      ),
    );
  }
}
