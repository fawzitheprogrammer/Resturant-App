import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/wallet/controllers/wallet_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class AddFundDialogueWidget extends StatefulWidget {
  const AddFundDialogueWidget({super.key});

  @override
  State<AddFundDialogueWidget> createState() => _AddFundDialogueWidgetState();
}

class _AddFundDialogueWidgetState extends State<AddFundDialogueWidget> {
  final TextEditingController inputAmountController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Get.find<WalletController>().isTextFieldEmpty('', isUpdate: false);
    Get.find<WalletController>().changeDigitalPaymentName('', isUpdate: false);

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: (){
              Get.back();
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).cardColor.withOpacity(0.5),
              ),
              padding: const EdgeInsets.all(3),
              child: const Icon(Icons.clear),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        GetBuilder<WalletController>(
          builder: (walletController) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).cardColor,
              ),
              width: context.width * 0.9,
              constraints: BoxConstraints(minHeight: context.height * 0.34, maxHeight: context.height * 0.7),
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Text('add_fund_to_wallet'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text('add_fund_form_secured_digital_payment_gateways'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextFieldWidget(
                    hintText: 'enter_amount'.tr,
                    inputType: TextInputType.number,
                    focusNode: focusNode,
                    inputAction: TextInputAction.done,
                    controller: inputAmountController,
                    textAlign: TextAlign.center,
                    onChanged: (String value){
                      try{
                        if(double.parse(value) > 0){
                          walletController.isTextFieldEmpty(value);
                        }
                      }catch(e) {
                        walletController.isTextFieldEmpty('');
                      }
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  walletController.amountEmpty ? Row(children: [
                    Text('payment_method'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Expanded(child: Text('faster_and_secure_way_to_pay_bill'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor))),
                  ]) : const SizedBox(),

                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [

                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        walletController.amountEmpty ? ListView.builder(
                            itemCount: Get.find<SplashController>().configModel!.activePaymentMethodList!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index){
                              bool isSelected = Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay! == walletController.digitalPaymentName;
                              return InkWell(
                                onTap: (){
                                  walletController.changeDigitalPaymentName(Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay!);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
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
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                      ]),
                    ),
                  ),

                  CustomButtonWidget(
                    buttonText: 'add_fund'.tr,
                    isLoading: walletController.isLoading,
                    onPressed: () => _onAddFundButtonClicked(walletController),
                  ),
                ],
              ),
            );
          }
        )
      ]),
    );
  }

  void _onAddFundButtonClicked(WalletController walletController) {
    if(inputAmountController.text.isEmpty){
      showCustomSnackBar('please_provide_transfer_amount'.tr);
    }else if(inputAmountController.text == '0'){
      showCustomSnackBar('you_can_not_add_zero_amount_in_wallet'.tr);
    }else if(walletController.digitalPaymentName == ''){
      showCustomSnackBar('please_select_payment_method'.tr);
    }else{
      double amount = double.parse(inputAmountController.text.replaceAll(Get.find<SplashController>().configModel!.currencySymbol!, ''));
      walletController.addFundToWallet(amount, walletController.digitalPaymentName!);
    }
  }

}
