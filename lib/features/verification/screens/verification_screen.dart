import 'dart:async';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/verification/controllers/verification_controller.dart';
import 'package:stackfood_multivendor/features/verification/screens/new_pass_screen.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_dialog_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationScreen extends StatefulWidget {
  final String? number;
  final bool fromSignUp;
  final String? token;
  final String password;
  const VerificationScreen({super.key, required this.number, required this.password, required this.fromSignUp,
    required this.token});

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  String? _number;
  Timer? _timer;
  int _seconds = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<VerificationController>().updateVerificationCode('', canUpdate: false);
    _number = widget.number!.startsWith('+') ? widget.number : '+${widget.number!.substring(1, widget.number!.length)}';
    _startTimer();
  }

  void _startTimer() {
    _seconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds - 1;
      if(_seconds == 0) {
        timer.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'phone_verification'.tr),
      body: SafeArea(child: Center(child: Scrollbar(controller: _scrollController, child: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Center(child: Container(
          width: context.width > 700 ? 700 : context.width,
          padding: context.width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
          decoration: context.width > 700 ? BoxDecoration(
            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, blurRadius: 5, spreadRadius: 1)],
          ) : null,
          child: GetBuilder<VerificationController>(builder: (verificationController) {
            return Column(children: [

              Get.find<SplashController>().configModel!.demo! ? Text(
                'for_demo_purpose'.tr, style: robotoRegular,
              ) : SizedBox(
                width: 210,
                child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                  RichText(text: TextSpan(children: [
                    TextSpan(text: 'enter_the_verification_sent_to'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                    TextSpan(text: ' $_number', style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                  ])),
                ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 35),
                child: PinCodeTextField(
                  length: 4,
                  appContext: context,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.slide,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    fieldHeight: 60,
                    fieldWidth: 60,
                    borderWidth: 1,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Theme.of(context).disabledColor.withOpacity(0.2),
                    inactiveColor: Theme.of(context).primaryColor.withOpacity(0.2),
                    activeColor: Theme.of(context).primaryColor.withOpacity(0.4),
                    activeFillColor: Theme.of(context).disabledColor.withOpacity(0.2),
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onChanged: verificationController.updateVerificationCode,
                  beforeTextPaste: (text) => true,
                ),
              ),

              verificationController.verificationCode.length == 4 ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: CustomButtonWidget(
                  radius: Dimensions.radiusDefault,
                  buttonText: 'verify'.tr,
                  isLoading: verificationController.isLoading,
                  onPressed: () {
                    Get.dialog(Center(child: NewPassScreen(resetToken: verificationController.verificationCode, number : _number, fromPasswordChange: true, fromDialog: true)));
                    if(widget.fromSignUp) {
                      verificationController.verifyPhone(_number, widget.token).then((value) {
                        if(value.isSuccess) {
                          showAnimatedDialog(context, Center(
                            child: Container(
                              width: 300,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
                              child: Column(mainAxisSize: MainAxisSize.min, children: [
                                Image.asset(Images.checked, width: 100, height: 100),
                                const SizedBox(height: Dimensions.paddingSizeLarge),
                                Text('verified'.tr, style: robotoBold.copyWith(
                                  fontSize: 30, color: Theme.of(context).textTheme.bodyLarge!.color,
                                  decoration: TextDecoration.none,
                                )),
                              ]),
                            ),
                          ), dismissible: false);
                          Future.delayed(const Duration(seconds: 2), () {
                            Get.offNamed(RouteHelper.getAccessLocationRoute('verification'));
                          });
                        }else {
                          showCustomSnackBar(value.message);
                        }
                      });
                    }else {
                      verificationController.verifyToken(_number).then((value) {
                        if(value.isSuccess) {
                          if(ResponsiveHelper.isDesktop(context)){
                            Get.dialog(Center(child: NewPassScreen(resetToken: verificationController.verificationCode, number : _number, fromPasswordChange: false, fromDialog: true )));
                          }else{
                            Get.toNamed(RouteHelper.getResetPasswordRoute(_number, verificationController.verificationCode, 'reset-password'));
                          }
                        }else {
                          showCustomSnackBar(value.message);
                        }
                      });
                    }
                  },
                ),
              ) : const SizedBox.shrink(),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 29),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    'did_not_receive_the_code'.tr,
                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                  ),
                  TextButton(
                    onPressed: _seconds < 1 ? () {
                      if(widget.fromSignUp) {
                        Get.find<AuthController>().login(_number, widget.password).then((value) {
                          if (value.isSuccess) {
                            _startTimer();
                            showCustomSnackBar('resend_code_successful'.tr, isError: false);
                          } else {
                            showCustomSnackBar(value.message);
                          }
                        });
                      }else {
                        verificationController.forgetPassword(_number).then((value) {
                          if (value.isSuccess) {
                            _startTimer();
                            showCustomSnackBar('resend_code_successful'.tr, isError: false);
                          } else {
                            showCustomSnackBar(value.message);
                          }
                        });
                      }
                    } : null,
                    child: Text('${'resend_it'.tr}${_seconds > 0 ? ' (${_seconds}s)' : ''}', style: TextStyle(color: Theme.of(context).primaryColor),),
                  ),
                ]),
              ),

            ]);
          }),
        )),
      )))),
    );
  }
}
