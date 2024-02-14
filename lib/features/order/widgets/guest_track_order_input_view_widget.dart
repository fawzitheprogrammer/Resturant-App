
import 'package:country_code_picker/country_code_picker.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/custom_validator.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestTrackOrderInputViewWidget extends StatefulWidget {
  const GuestTrackOrderInputViewWidget({super.key});

  @override
  State<GuestTrackOrderInputViewWidget> createState() => _GuestTrackOrderInputViewWidgetState();
}

class _GuestTrackOrderInputViewWidgetState extends State<GuestTrackOrderInputViewWidget> {
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _orderFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  String? _countryDialCode;

  @override
  void initState() {
    super.initState();

    _countryDialCode = Get.find<AuthController>().getUserCountryCode().isNotEmpty
        ? Get.find<AuthController>().getUserCountryCode()
        : CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: Dimensions.radiusExtraLarge, vertical: Dimensions.paddingSizeLarge),
      child: Center(
        child: SingleChildScrollView(
          child: FooterViewWidget(
            child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: Column(children: [

                SizedBox(height: ResponsiveHelper.isDesktop(context) ? 100 : 0),

                CustomTextFieldWidget(
                  titleText: 'order_id'.tr,
                  hintText: '',
                  controller: _orderIdController,
                  focusNode: _orderFocus,
                  nextFocus: _phoneFocus,
                  inputType: TextInputType.number,
                  showTitle: ResponsiveHelper.isDesktop(context),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                CustomTextFieldWidget(
                  titleText: 'enter_phone_number'.tr,
                  hintText: '',
                  controller: _phoneNumberController,
                  focusNode: _phoneFocus,
                  inputType: TextInputType.phone,
                  inputAction: TextInputAction.done,
                  isPhone: true,
                  showTitle: ResponsiveHelper.isDesktop(context),
                  onCountryChanged: (CountryCode countryCode) {
                    _countryDialCode = countryCode.dialCode;
                  },
                  countryDialCode: _countryDialCode ?? Get.find<LocalizationController>().locale.countryCode,
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                GetBuilder<OrderController>(
                    builder: (orderController) {
                      return CustomButtonWidget(
                        buttonText: 'track_order'.tr,
                        isLoading: orderController.isLoading,
                        width: ResponsiveHelper.isDesktop(context) ? 300 : double.infinity,
                        onPressed: () async {
                          String phone = _phoneNumberController.text.trim();
                          String orderId = _orderIdController.text.trim();
                          String numberWithCountryCode = _countryDialCode! + phone;
                          PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
                          numberWithCountryCode = phoneValid.phone;

                          if(orderId.isEmpty) {
                            showCustomSnackBar('please_enter_order_id'.tr);
                          } else if (phone.isEmpty) {
                            showCustomSnackBar('enter_phone_number'.tr);
                          }else if (!phoneValid.isValid) {
                            showCustomSnackBar('invalid_phone_number'.tr);
                          } else {
                            orderController.trackOrder(orderId, null, false, contactNumber: numberWithCountryCode, fromGuestInput: true).then((response) {
                              if(response.isSuccess) {
                                Get.toNamed(RouteHelper.getGuestTrackOrderScreen(orderId, numberWithCountryCode));
                              }
                            });
                          }
                        },
                      );
                    }
                )

              ]),
            ),
          ),
        ),
      ),
    );
  }
}
