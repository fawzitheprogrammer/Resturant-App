import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaveButtonWidget extends StatelessWidget {
  final LocalizationController localizationController;
  final bool? fromMenu;
  const SaveButtonWidget({super.key, required this.localizationController, this.fromMenu});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Center(
          child: Text(
            'you_can_change_language'.tr,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
          ),
        ),
      ),

      CustomButtonWidget(
        radius: 10,
        buttonText: 'save'.tr,
        margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        onPressed: () {
          if(localizationController.languages.isNotEmpty && localizationController.selectedLanguageIndex != -1) {
            localizationController.setLanguage(Locale(
              AppConstants.languages[localizationController.selectedLanguageIndex].languageCode!,
              AppConstants.languages[localizationController.selectedLanguageIndex].countryCode,
            ));
            if (fromMenu!) {
              Navigator.pop(context);
            } else {
              Get.offNamed(RouteHelper.getOnBoardingRoute());
            }
          }else {
            showCustomSnackBar('select_a_language'.tr);
          }
        },
      ),
    ]);
  }
}