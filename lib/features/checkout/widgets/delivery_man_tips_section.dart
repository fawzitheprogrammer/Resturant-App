import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/tips_widget.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
class DeliveryManTipsSection extends StatefulWidget {
  final bool takeAway;
  final JustTheController tooltipController3;
  final CheckoutController checkoutController;
  final double totalPrice;
  final Function(double x) onTotalChange;
  const DeliveryManTipsSection({super.key, required this.takeAway, required this.tooltipController3, required this.checkoutController, required this.totalPrice, required this.onTotalChange});

  @override
  State<DeliveryManTipsSection> createState() => _DeliveryManTipsSectionState();
}

class _DeliveryManTipsSectionState extends State<DeliveryManTipsSection> {
  bool canCheckSmall = false;

  @override
  Widget build(BuildContext context) {
    double total = widget.totalPrice;
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Column(
      children: [
        (!widget.checkoutController.subscriptionOrder && !widget.takeAway && Get.find<SplashController>().configModel!.dmTipsStatus == 1) ? Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, spreadRadius: 1, offset: const Offset(1, 2))],
          ),
          margin: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : Dimensions.fontSizeDefault),
          padding: EdgeInsets.all(isDesktop ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Row(children: [
              Text('delivery_man_tips'.tr, style: robotoMedium),

              JustTheTooltip(
                backgroundColor: Colors.black87,
                controller: widget.tooltipController3,
                preferredDirection: AxisDirection.right,
                tailLength: 14,
                tailBaseWidth: 20,
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('it_s_a_great_way_to_show_your_appreciation_for_their_hard_work'.tr,style: robotoRegular.copyWith(color: Colors.white)),
                ),
                child: InkWell(
                  onTap: () => widget.tooltipController3.showTooltip(),
                  child: const Icon(Icons.info_outline),
                ),
              ),

              const Expanded(child: SizedBox()),

              (widget.checkoutController.selectedTips == AppConstants.tips.length-1) ? const SizedBox() : SizedBox(
                width: ResponsiveHelper.isDesktop(context) ? 150 : 120,
                child: ListTile(
                  onTap: () => widget.checkoutController.toggleDmTipSave(),
                  trailing: Checkbox(
                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    activeColor: Theme.of(context).primaryColor,
                    value: widget.checkoutController.isDmTipSave,
                    onChanged: (bool? isChecked) => widget.checkoutController.toggleDmTipSave(),
                  ),
                  title: Text('save_for_later'.tr, style: robotoMedium.copyWith(color: isDesktop ? Theme.of(context).textTheme.bodyMedium!.color! : Theme.of(context).primaryColor)),
                  contentPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                  dense: true,
                  horizontalTitleGap: 0,
                ),
              ),

            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            SizedBox(
              height: (widget.checkoutController.selectedTips == AppConstants.tips.length-1) && widget.checkoutController.canShowTipsField
                  ? 0 : 60,
              child: (widget.checkoutController.selectedTips == AppConstants.tips.length-1) && widget.checkoutController.canShowTipsField
              ? const SizedBox() : ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: AppConstants.tips.length,
                itemBuilder: (context, index) {
                  return TipsWidget(
                    index: index,
                    title: AppConstants.tips[index] == '0' ? 'not_now'.tr : (index != AppConstants.tips.length -1) ? PriceConverter.convertPrice(double.parse(AppConstants.tips[index].toString()), forDM: true) : AppConstants.tips[index].tr,
                    isSelected: widget.checkoutController.selectedTips == index,
                    isSuggested: index != 0 && AppConstants.tips[index] == widget.checkoutController.mostDmTipAmount.toString(),
                    onTap: () {
                      total = total - widget.checkoutController.tips;
                      widget.checkoutController.updateTips(index);
                      if(widget.checkoutController.selectedTips != AppConstants.tips.length-1) {
                        widget.checkoutController.addTips(double.parse(AppConstants.tips[index]));
                      }
                      if(widget.checkoutController.selectedTips == AppConstants.tips.length-1) {
                        widget.checkoutController.showTipsField();
                      }
                      widget.checkoutController.tipController.text = widget.checkoutController.tips.toString();
                      if(widget.checkoutController.isPartialPay || widget.checkoutController.paymentMethodIndex == 1) {
                        widget.checkoutController.checkBalanceStatus(total, extraCharge: widget.checkoutController.tips);
                      }
                    },
                  );
                },
              ),
            ),
            SizedBox(height: (widget.checkoutController.selectedTips == AppConstants.tips.length-1) && widget.checkoutController.canShowTipsField ? Dimensions.paddingSizeExtraSmall : 0),

            widget.checkoutController.selectedTips == AppConstants.tips.length-1 ? Row(children: [
              Expanded(
                child: CustomTextFieldWidget(
                  titleText: 'enter_amount'.tr,
                  controller: widget.checkoutController.tipController,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.number,
                  onSubmit: (value) async {
                    if(value.isNotEmpty){
                      try{
                        if(double.parse(value) >= 0){
                          if(Get.find<AuthController>().isLoggedIn()) {
                            total = total - widget.checkoutController.tips;
                            await widget.checkoutController.addTips(double.parse(value));
                            total = total + widget.checkoutController.tips;
                            widget.onTotalChange(total);
                            if(Get.find<ProfileController>().userInfoModel!.walletBalance! < total && widget.checkoutController.paymentMethodIndex == 1){
                              widget.checkoutController.checkBalanceStatus(total);
                              canCheckSmall = true;
                            } else if(Get.find<ProfileController>().userInfoModel!.walletBalance! > total && canCheckSmall && widget.checkoutController.isPartialPay){
                              widget.checkoutController.checkBalanceStatus(total);
                            }
                          } else {
                            widget.checkoutController.addTips(double.parse(value));
                          }

                        }else{
                          showCustomSnackBar('tips_can_not_be_negative'.tr);
                        }
                      } catch(e) {
                        showCustomSnackBar('invalid_input'.tr);
                        widget.checkoutController.addTips(0.0);
                        widget.checkoutController.tipController.text = widget.checkoutController.tipController.text.substring(0, widget.checkoutController.tipController.text.length-1);
                        widget.checkoutController.tipController.selection = TextSelection.collapsed(offset: widget.checkoutController.tipController.text.length);
                      }
                    }else{
                      widget.checkoutController.addTips(0.0);
                    }
                  },

                  onChanged: (String value) async {
                    if(value.isNotEmpty){
                      try{
                        if(double.parse(value) >= 0){
                          if(Get.find<AuthController>().isLoggedIn()) {
                            total = total - widget.checkoutController.tips;
                            await widget.checkoutController.addTips(double.parse(value));
                            total = total + widget.checkoutController.tips;
                            widget.onTotalChange(total);
                            if(Get.find<ProfileController>().userInfoModel!.walletBalance! < total && widget.checkoutController.paymentMethodIndex == 1){
                              widget.checkoutController.checkBalanceStatus(total);
                              canCheckSmall = true;
                            } else if(Get.find<ProfileController>().userInfoModel!.walletBalance! > total && canCheckSmall && widget.checkoutController.isPartialPay){
                              widget.checkoutController.checkBalanceStatus(total);
                            }
                          } else {
                            widget.checkoutController.addTips(double.parse(value));
                          }

                        }else{
                          showCustomSnackBar('tips_can_not_be_negative'.tr);
                        }
                      } catch(e){
                        showCustomSnackBar('invalid_input'.tr);
                        widget.checkoutController.addTips(0.0);
                        widget.checkoutController.tipController.text = widget.checkoutController.tipController.text.substring(0, widget.checkoutController.tipController.text.length-1);
                        widget.checkoutController.tipController.selection = TextSelection.collapsed(offset: widget.checkoutController.tipController.text.length);
                      }
                    }else{
                      widget.checkoutController.addTips(0.0);
                    }
                  },
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              InkWell(
                onTap: () {
                  widget.checkoutController.updateTips(0);
                  widget.checkoutController.showTipsField();
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: const Icon(Icons.clear),
                ),
              ),

            ]) : const SizedBox(),

          ]),
        ) : const SizedBox.shrink(),

        SizedBox(height: (!widget.takeAway && Get.find<SplashController>().configModel!.dmTipsStatus == 1)
            ? Dimensions.paddingSizeSmall : 0),
      ],
    );
  }
}
