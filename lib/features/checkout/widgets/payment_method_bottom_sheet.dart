import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/offline_payment_button.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/payment_button_new.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/business/controllers/business_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class PaymentMethodBottomSheet extends StatefulWidget {
  final bool isCashOnDeliveryActive;
  final bool isDigitalPaymentActive;
  final bool isOfflinePaymentActive;
  final bool isWalletActive;
  final double totalPrice;
  final bool isSubscriptionPackage;
  const PaymentMethodBottomSheet({
    super.key, required this.isCashOnDeliveryActive, required this.isDigitalPaymentActive,
    required this.isWalletActive, required this.totalPrice, this.isSubscriptionPackage = false, required this.isOfflinePaymentActive});

  @override
  State<PaymentMethodBottomSheet> createState() => _PaymentMethodBottomSheetState();
}

class _PaymentMethodBottomSheetState extends State<PaymentMethodBottomSheet> {
  bool canSelectWallet = true;
  bool notHideCod = true;
  bool notHideWallet = true;
  bool notHideDigital = true;
  final JustTheController tooltipController = JustTheController();

  @override
  void initState() {
    super.initState();

    if(!widget.isSubscriptionPackage && !Get.find<AuthController>().isGuestLoggedIn()){
      double walletBalance = Get.find<ProfileController>().userInfoModel!.walletBalance!;
      if(walletBalance < widget.totalPrice){
        canSelectWallet = false;
      }
      if(Get.find<CheckoutController>().isPartialPay){
        notHideWallet = false;
        if(Get.find<SplashController>().configModel!.partialPaymentMethod! == 'cod'){
          notHideCod = true;
          notHideDigital = false;
        } else if(Get.find<SplashController>().configModel!.partialPaymentMethod! == 'digital_payment'){
          notHideCod = false;
          notHideDigital = true;
        } else if(Get.find<SplashController>().configModel!.partialPaymentMethod! == 'both'){
          notHideCod = true;
          notHideDigital = true;
        }
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();

    return SizedBox(
      width: 550,
      child: GetBuilder<CheckoutController>(builder: (checkoutController) {
          return GetBuilder<BusinessController>(builder: (businessController) {
              return Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.vertical(top: const Radius.circular(Dimensions.radiusLarge), bottom: Radius.circular(ResponsiveHelper.isDesktop(context) ? Dimensions.radiusLarge : 0)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeLarge),
                child: Column(mainAxisSize: MainAxisSize.min, children: [

                  ResponsiveHelper.isDesktop(context) ? Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 30, width: 30,
                        margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(50)),
                        child: const Icon(Icons.clear),
                      ),
                    ),
                  ) : Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 4, width: 35,
                      margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Align(alignment: Alignment.center, child: Text('payment_method'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge))),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          !widget.isSubscriptionPackage && notHideCod ? Text('choose_payment_method'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)) : const SizedBox(),
                          SizedBox(height: !widget.isSubscriptionPackage && notHideCod ? Dimensions.paddingSizeExtraSmall : 0),

                          !widget.isSubscriptionPackage && notHideCod ? Text(
                            'click_one_of_the_option_below'.tr,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                          ) : const SizedBox(),
                          SizedBox(height: !widget.isSubscriptionPackage && notHideCod ? Dimensions.paddingSizeLarge : 0),

                          !widget.isSubscriptionPackage ? Row(children: [
                            widget.isCashOnDeliveryActive && notHideCod ? Expanded(
                              child: PaymentButtonNew(
                                icon: Images.codIcon,
                                title: 'cash_on_delivery'.tr,
                                isSelected: checkoutController.paymentMethodIndex == 0,
                                onTap: () {
                                  checkoutController.setPaymentMethod(0);
                                },
                              ),
                            ) : const SizedBox(),
                            SizedBox(width: widget.isWalletActive && notHideWallet && !checkoutController.subscriptionOrder && isLoggedIn ? Dimensions.paddingSizeLarge : 0),

                            widget.isWalletActive && notHideWallet && !checkoutController.subscriptionOrder && isLoggedIn ? Expanded(
                              child: PaymentButtonNew(
                                icon: Images.partialWallet,
                                title: 'pay_via_wallet'.tr,
                                isSelected: checkoutController.paymentMethodIndex == 1,
                                onTap: () {
                                  if(canSelectWallet) {
                                    checkoutController.setPaymentMethod(1);
                                  } else if(checkoutController.isPartialPay){
                                    showCustomSnackBar('you_can_not_user_wallet_in_partial_payment'.tr);
                                    Get.back();
                                  } else{
                                    showCustomSnackBar('your_wallet_have_not_sufficient_balance'.tr);
                                    Get.back();
                                  }
                                },
                              ),
                            ) : const SizedBox(),

                          ]) : const SizedBox(),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          widget.isDigitalPaymentActive && notHideDigital && !checkoutController.subscriptionOrder ? Row(children: [
                            Text('pay_via_online'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                            Text(
                              'faster_and_secure_way_to_pay_bill'.tr,
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                            ),
                          ]) : const SizedBox(),
                          SizedBox(height: /*widget.isNewPluginGetWays && */widget.isDigitalPaymentActive && notHideDigital ? Dimensions.paddingSizeLarge : 0),

                          widget.isDigitalPaymentActive && notHideDigital && !checkoutController.subscriptionOrder ? ListView.builder(
                              itemCount: Get.find<SplashController>().configModel!.activePaymentMethodList!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index){
                                bool isSelected;
                                if(widget.isSubscriptionPackage) {
                                  isSelected = businessController.paymentIndex == 1 && Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay! == businessController.digitalPaymentName;
                                } else {
                                  isSelected = checkoutController.paymentMethodIndex == 2 && Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay! == checkoutController.digitalPaymentName;
                                }
                                return InkWell(
                                  onTap: (){

                                    if(widget.isSubscriptionPackage) {
                                      businessController.setPaymentIndex(1);
                                      businessController.changeDigitalPaymentName(Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay!);
                                    } else {
                                      checkoutController.setPaymentMethod(2);
                                      checkoutController.changeDigitalPaymentName(Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay!);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.05) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 0.3),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                                    margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                    child: Row(children: [
                                      Container(
                                        height: 20, width: 20,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                                            border: Border.all(color: Theme.of(context).disabledColor)
                                        ),
                                        child: Icon(Icons.check, color: Theme.of(context).cardColor, size: 16),
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeDefault),

                                      CustomImageWidget(
                                        height: 20, fit: BoxFit.contain,
                                        image: '${Get.find<SplashController>().configModel!.baseUrls!.gatewayImageUrl}/${Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWayImage}',
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeSmall),

                                      Text(
                                        Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWayTitle!,
                                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                                      ),
                                    ]),
                                  ),
                                );
                              }) : const SizedBox(),

                          widget.isOfflinePaymentActive && !checkoutController.subscriptionOrder ? OfflinePaymentButton(
                            isSelected: checkoutController.paymentMethodIndex == 3,
                            offlineMethodList: checkoutController.offlineMethodList,
                            isOfflinePaymentActive: widget.isOfflinePaymentActive,
                            onTap: () => checkoutController.setPaymentMethod(3),
                            checkoutController: checkoutController, tooltipController: tooltipController,
                          ) : const SizedBox(),

                        ],
                      ),
                    ),
                  ),

                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child: CustomButtonWidget(
                        buttonText: 'select'.tr,
                        onPressed: () => Get.back(),
                      ),
                    ),
                  ),
                ]),
              );
            }
          );
        }
      ),
    );
  }
}
