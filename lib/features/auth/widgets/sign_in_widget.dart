import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/auth/screens/sign_up_screen.dart';
import 'package:stackfood_multivendor/features/auth/widgets/trams_conditions_check_box_widget.dart';
import 'package:stackfood_multivendor/features/auth/widgets/guest_button_widget.dart';
import 'package:stackfood_multivendor/features/auth/widgets/social_login_widget.dart';
import 'package:stackfood_multivendor/features/verification/screens/forget_pass_screen.dart';
import 'package:stackfood_multivendor/helper/custom_validator.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInWidget extends StatefulWidget {
  final bool exitFromApp;
  final bool backFromThis;
  const SignInWidget({super.key, required this.exitFromApp, required this.backFromThis});

  @override
  SignInWidgetState createState() => SignInWidgetState();
}

class SignInWidgetState extends State<SignInWidget> {
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _countryDialCode;

  @override
  void initState() {
    super.initState();

    _countryDialCode = Get.find<AuthController>().getUserCountryCode().isNotEmpty ? Get.find<AuthController>().getUserCountryCode()
        : CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    _phoneController.text =  Get.find<AuthController>().getUserNumber();
    _passwordController.text = Get.find<AuthController>().getUserPassword();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return GetBuilder<AuthController>(builder: (authController) {
      return Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
        CustomTextFieldWidget(
          titleText: isDesktop ? 'phone'.tr : 'enter_phone_number'.tr,
          hintText: 'enter_phone_number'.tr,
          controller: _phoneController,
          focusNode: _phoneFocus,
          nextFocus: _passwordFocus,
          inputType: TextInputType.phone,
          isPhone: true,
          showTitle: isDesktop,
          onCountryChanged: (CountryCode countryCode) {
            _countryDialCode = countryCode.dialCode;
          },
          countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
              : Get.find<LocalizationController>().locale.countryCode,
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        CustomTextFieldWidget(
          titleText: isDesktop ? 'password'.tr : 'enter_your_password'.tr,
          hintText: 'enter_your_password'.tr,
          controller: _passwordController,
          focusNode: _passwordFocus,
          inputAction: TextInputAction.done,
          inputType: TextInputType.visiblePassword,
          prefixIcon: Icons.lock,
          isPassword: true,
          showTitle: isDesktop,
          onSubmit: (text) => (GetPlatform.isWeb) ? _login(authController, _countryDialCode!) : null,
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),


        Row(children: [
          Expanded(
            child: ListTile(
              onTap: () => authController.toggleRememberMe(),
              leading: Checkbox(
                activeColor: Theme.of(context).primaryColor,
                value: authController.isActiveRememberMe,
                onChanged: (bool? isChecked) => authController.toggleRememberMe(),
              ),
              title: Text('remember_me'.tr),
              contentPadding: EdgeInsets.zero,
              dense: true,
              horizontalTitleGap: 0,
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              if(isDesktop) {
                Get.dialog(const Center(child: ForgetPassScreen(fromSocialLogin: false, socialLogInModel: null, fromDialog: true)));
              } else {
                Get.toNamed(RouteHelper.getForgotPassRoute(false, null));
              }
            },
            child: Text('${'forgot_password'.tr}?', style: robotoRegular.copyWith( fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor)),
          ),
        ]),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        isDesktop ? const SizedBox() : TramsConditionsCheckBoxWidget(authController: authController),
        isDesktop ? const SizedBox() : const SizedBox(height: Dimensions.paddingSizeSmall),

        CustomButtonWidget(
          height: isDesktop ? 45 : null,
          width:  isDesktop ? 180 : null,
          buttonText: isDesktop ? 'login'.tr : 'sign_in'.tr,
          radius: isDesktop ? Dimensions.radiusSmall : Dimensions.radiusDefault,
          isBold: isDesktop ? false : true,
          isLoading: authController.isLoading,
          onPressed: authController.acceptTerms ? () => _login(authController, _countryDialCode!) : null,
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        !isDesktop ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('do_not_have_account'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),

          InkWell(
            onTap: authController.isLoading ? null : () {
              if(isDesktop){
                Get.back();
                Get.dialog(const SignUpScreen());
              }else{
                Get.toNamed(RouteHelper.getSignUpRoute());
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Text('sign_up'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
            ),
          ),
        ]) : const SizedBox(),

        const SizedBox(height: Dimensions.paddingSizeSmall),

        const SocialLoginWidget(),

        isDesktop ? const SizedBox() : const GuestButtonWidget(),

      ]);
    });
  }

  void _login(AuthController authController, String countryDialCode) async {
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String numberWithCountryCode = countryDialCode+phone;
    PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;

    if (phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (!phoneValid.isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    }else if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    }else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    }else {
      authController.login(numberWithCountryCode, password, alreadyInApp: widget.backFromThis).then((status) async {
        if (status.isSuccess) {
          _processSuccessSetup(authController, phone, password, countryDialCode, status, numberWithCountryCode);
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }

  void _processSuccessSetup(AuthController authController, String phone, String password, String countryDialCode, ResponseModel status, String numberWithCountryCode) {
    if (authController.isActiveRememberMe) {
      authController.saveUserNumberAndPassword(phone, password, countryDialCode);
    } else {
      authController.clearUserNumberAndPassword();
    }
    String token = status.message!.substring(1, status.message!.length);
    if(Get.find<SplashController>().configModel!.customerVerification! && int.parse(status.message![0]) == 0) {
      List<int> encoded = utf8.encode(password);
      String data = base64Encode(encoded);
      Get.toNamed(RouteHelper.getVerificationRoute(numberWithCountryCode, token, RouteHelper.signUp, data));
    }else {
      if(widget.backFromThis) {
        if(ResponsiveHelper.isDesktop(context)){
          Get.offAllNamed(RouteHelper.getInitialRoute(fromSplash: false));
        } else {
          Get.back();
        }
      }else {
        Get.find<SplashController>().navigateToLocationScreen('sign-in', offNamed: true);
      }
    }
  }
}
