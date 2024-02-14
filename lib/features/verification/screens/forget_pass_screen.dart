import 'package:country_code_picker/country_code_picker.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/social_log_in_body_model.dart';
import 'package:stackfood_multivendor/features/verification/controllers/verification_controller.dart';
import 'package:stackfood_multivendor/helper/custom_validator.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassScreen extends StatefulWidget {
  final bool fromSocialLogin;
  final SocialLogInBodyModel? socialLogInModel;
  final bool fromDialog;
  const ForgetPassScreen({super.key, required this.fromSocialLogin, required this.socialLogInModel, this.fromDialog = false});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _numberController = TextEditingController();
  String? _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).cardColor,
      appBar: CustomAppBarWidget(title: widget.fromSocialLogin ? 'phone'.tr : 'forgot_password'.tr),
      body: Center(child: Scrollbar(controller: _scrollController, child: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Center(
            child: Container(
              height: widget.fromDialog ? 600 : null,
              width: widget.fromDialog ? 475 : context.width > 700 ? 700 : context.width,
              //padding: widget.fromDialog ? const EdgeInsets.all(Dimensions.paddingSizeOverLarge) : context.width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : const EdgeInsets.all(Dimensions.paddingSizeLarge),
              decoration: context.width > 700 ? BoxDecoration(
                color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                boxShadow:  ResponsiveHelper.isDesktop(context) ?  null : [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, blurRadius: 5, spreadRadius: 1)],
              ) : null,
              child: Column(
                children: [
                  ResponsiveHelper.isDesktop(context) ? Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.clear),
                    ),
                  ) : const SizedBox(),

                  Padding(
                    padding: widget.fromDialog ? const EdgeInsets.all(Dimensions.paddingSizeOverLarge) : context.width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Column(children: [

                      Image.asset(Images.forgot, height:  widget.fromDialog ? 160 : 220),

                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Text('please_enter_mobile'.tr, style: robotoRegular.copyWith(fontSize: widget.fromDialog ? Dimensions.fontSizeSmall : null), textAlign: TextAlign.center),
                      ),

                      CustomTextFieldWidget(
                        titleText: 'phone'.tr,
                        controller: _numberController,
                        inputType: TextInputType.phone,
                        inputAction: TextInputAction.done,
                        isPhone: true,
                        showTitle: ResponsiveHelper.isDesktop(context),
                        onCountryChanged: (CountryCode countryCode) {
                          _countryDialCode = countryCode.dialCode;
                        },
                        countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                            : Get.find<LocalizationController>().locale.countryCode,
                        onSubmit: (text) => GetPlatform.isWeb ? _onPressedForgetPass(_countryDialCode!) : null,
                      ),

                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      GetBuilder<VerificationController>(builder: (verificationController) {
                        return GetBuilder<AuthController>(builder: (authController) {
                          return CustomButtonWidget(
                            radius: Dimensions.radiusDefault,
                            buttonText: widget.fromDialog ? 'verify'.tr : 'next'.tr,
                            isLoading: widget.fromSocialLogin ? authController.isLoading : verificationController.isLoading,
                            onPressed: () => _onPressedForgetPass(_countryDialCode!),
                          );
                        });
                      }),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      RichText(text: TextSpan(children: [
                        TextSpan(
                          text: '${'if_you_have_any_queries_feel_free_to_contact_with_our'.tr} ',
                          style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                        ),
                        TextSpan(
                          text: 'help_and_support'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.toNamed(RouteHelper.getSupportRoute()),
                        ),
                      ]), textAlign: TextAlign.center, maxLines: 3),

                    ]),
                  )
                ],
              ),
            )

        ),
      ))),
    );
  }

  void _onPressedForgetPass(String countryCode) async {
    String phone = _numberController.text.trim();

    String numberWithCountryCode = countryCode+phone;
    PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;

    if (phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (!phoneValid.isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    }else {
      if(widget.fromSocialLogin) {
        widget.socialLogInModel!.phone = numberWithCountryCode;
        Get.find<AuthController>().registerWithSocialMedia(widget.socialLogInModel!);
      }else {
        Get.find<VerificationController>().forgetPassword(numberWithCountryCode).then((status) async {
          if (status.isSuccess) {
            Get.toNamed(RouteHelper.getVerificationRoute(numberWithCountryCode, '', RouteHelper.forgotPassword, ''));
          }else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }
  }
}
