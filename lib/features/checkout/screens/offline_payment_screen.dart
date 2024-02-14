import 'dart:convert';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/offline_method_model.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/place_order_body_model.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/pricing_view_model.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfflinePaymentScreen extends StatefulWidget {
  final PlaceOrderBodyModel placeOrderBodyModel;
  final int zoneId;
  final double total;
  final double? maxCodOrderAmount;
  final bool fromCart;
  final bool isCashOnDeliveryActive;
  final PricingViewModel pricingView;

  const OfflinePaymentScreen({super.key, required this.placeOrderBodyModel, required this.zoneId, required this.total, required this.maxCodOrderAmount,
    required this.fromCart, required this.isCashOnDeliveryActive, required this.pricingView});

  @override
  State<OfflinePaymentScreen> createState() => _OfflinePaymentScreenState();
}

class _OfflinePaymentScreenState extends State<OfflinePaymentScreen> {
  //PageController pageController = PageController(viewportFraction: 0.85, initialPage: Get.find<OrderController>().selectedOfflineBankIndex);
  final TextEditingController _customerNoteController = TextEditingController();
  final FocusNode _customerNoteNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    initCall();
  }

  Future<void> initCall() async {
    if(Get.find<CheckoutController>().offlineMethodList == null){
      await Get.find<CheckoutController>().getOfflineMethodList();
    }
    Get.find<CheckoutController>().informationControllerList = [];
    Get.find<CheckoutController>().informationFocusList = [];
    if(Get.find<CheckoutController>().offlineMethodList != null && Get.find<CheckoutController>().offlineMethodList!.isNotEmpty) {
      for(int index=0; index<Get.find<CheckoutController>().offlineMethodList![Get.find<CheckoutController>().selectedOfflineBankIndex].methodInformations!.length; index++) {
        Get.find<CheckoutController>().informationControllerList.add(TextEditingController());
        Get.find<CheckoutController>().informationFocusList.add(FocusNode());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'offline_payment'.tr),
      body: GetBuilder<CheckoutController>(builder: (checkoutController) {
        List<MethodInformations>? methodInformation;
        List<MethodFields>? methodFields;
        if(checkoutController.offlineMethodList != null){
          methodInformation = checkoutController.offlineMethodList![checkoutController.selectedOfflineBankIndex].methodInformations;
          methodFields = checkoutController.offlineMethodList![checkoutController.selectedOfflineBankIndex].methodFields;
        }

        return methodFields != null ? Column(children: [
          WebScreenTitleWidget(title: 'offline_payment'.tr),

          Expanded(child: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: FooterViewWidget(
              child: Center(
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: /*ResponsiveHelper.isMobile(context) ?*/ Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, spreadRadius: 1)],
                        ),
                        child: ExpansionTile(
                          initiallyExpanded: true,
                          trailing: Icon(Icons.arrow_drop_down_sharp, size: 35 , color: Theme.of(context).textTheme.bodyMedium!.color),
                          title: Text('select_payment_information'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyMedium!.color)),
                          children: [
                            Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  margin: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2), width: 2),
                                  ),
                                  child: Column(children: [

                                    Row(children: [

                                      Image.asset(Images.bankInfoIcon, width: 25, height: 25, color: Theme.of(context).primaryColor),
                                      const SizedBox(width: Dimensions.paddingSizeSmall),

                                      Text('${'bank_information'.tr} (${checkoutController.offlineMethodList![checkoutController.selectedOfflineBankIndex].methodName})', style: robotoMedium),

                                    ]),
                                    const SizedBox(height: Dimensions.paddingSizeDefault),

                                    ListView.builder(
                                      itemCount: methodFields!.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                                          child: InfoTextRowWidget(
                                            title: methodFields![index].inputName!.toString().replaceAll('_', ' '),
                                            value: methodFields[index].inputData!,
                                          ),
                                        );
                                      },
                                    ),

                                  ]),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Text(
                      '${'amount'.tr} '' ${PriceConverter.convertPrice(widget.total)}',
                      style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'payment_info'.tr,
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                          ),
                        ),

                        ListView.builder(
                          itemCount: checkoutController.informationControllerList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                              child: CustomTextFieldWidget(
                                titleText: methodInformation![i].customerPlaceholder!,
                                controller: checkoutController.informationControllerList[i],
                                focusNode: checkoutController.informationFocusList[i],
                                nextFocus: i != checkoutController.informationControllerList.length-1 ? checkoutController.informationFocusList[i+1] : _customerNoteNode,
                              ),
                            );
                          },
                        ),

                        CustomTextFieldWidget(
                          titleText: 'note'.tr,
                          controller: _customerNoteController,
                          focusNode: _customerNoteNode,
                          inputAction: TextInputAction.done,
                          maxLines: 3,
                        ),

                      ]),
                    ),

                    ResponsiveHelper.isDesktop(context) ? Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                          margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                          child: CustomButtonWidget(
                            width: ResponsiveHelper.isDesktop(context) ? 300 : double.infinity,
                            buttonText: 'complete'.tr,
                            isLoading: checkoutController.isLoading,
                            onPressed: () async {
                              bool complete = _completelyProvideInput(methodInformation, checkoutController);
                              String text = _setMessageText(methodInformation, checkoutController);

                              if(complete) {
                                await _saveOfflineInformation(checkoutController, methodInformation);
                              } else {
                                showCustomSnackBar(text);
                              }
                            },
                          ),
                        ),
                      ],
                    ) : const SizedBox(),

                  ]),
                ),
              ),
            ),
          )),

          ResponsiveHelper.isDesktop(context) ? const SizedBox() : Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.1), blurRadius: 10)],
            ),
            child: CustomButtonWidget(
              buttonText: 'complete'.tr,
              isLoading: checkoutController.isLoading,
              onPressed: () async {
                bool complete = _completelyProvideInput(methodInformation, checkoutController);
                String text = _setMessageText(methodInformation, checkoutController);

                if(complete) {
                  await _saveOfflineInformation(checkoutController, methodInformation);
                } else {
                  showCustomSnackBar(text);
                }
              },
            ),
          ),

        ]) : const Center(child: CircularProgressIndicator());
      }),
    );
  }

  bool _completelyProvideInput(List<MethodInformations>? methodInformation, CheckoutController checkoutController) {
    bool complete = false;
    for(int i = 0; i<methodInformation!.length; i++){
      if(methodInformation[i].isRequired!) {
        if(checkoutController.informationControllerList[i].text.isEmpty){
          complete = false;
          break;
        } else {
          complete = true;
        }
      } else {
        complete = true;
      }
    }
    return complete;
  }

  String _setMessageText(List<MethodInformations>? methodInformation, CheckoutController checkoutController) {
    String text = '';
    for(int i = 0; i<methodInformation!.length; i++){
      if(methodInformation[i].isRequired!) {
        if(checkoutController.informationControllerList[i].text.isEmpty){
          text = methodInformation[i].customerPlaceholder!;
          break;
        }
      }
    }
    return text;
  }

  Future<void> _saveOfflineInformation(CheckoutController checkoutController, List<MethodInformations>? methodInformation) async {
    String methodId = checkoutController.offlineMethodList![checkoutController.selectedOfflineBankIndex].id.toString();
    String? orderId = await checkoutController.placeOrder(widget.placeOrderBodyModel, widget.zoneId, widget.total, widget.maxCodOrderAmount, widget.fromCart, widget.isCashOnDeliveryActive, isOfflinePay: true);

    if(orderId.isNotEmpty) {
      Map<String, String> data = {
        "_method": "put",
        "order_id": orderId,
        "method_id": methodId,
        "customer_note": _customerNoteController.text,
      };

      for(int i = 0; i<methodInformation!.length; i++){
        data.addAll({
          methodInformation[i].customerInput! : checkoutController.informationControllerList[i].text,
        });
      }

      checkoutController.saveOfflineInfo(jsonEncode(data)).then((success) {
        if(success){
          Get.offAllNamed(RouteHelper.getOrderDetailsRoute(int.parse(orderId), fromOffline: true, contactNumber: widget.placeOrderBodyModel.contactPersonNumber));
        }
      });
    }
  }

}

class InfoTextRowWidget extends StatelessWidget {
  final String title;
  final String value;
  const InfoTextRowWidget({super.key, required this.title, required this.value,});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      
      Expanded(
        flex: ResponsiveHelper.isDesktop(context) ? 1 : 1,
        child: Text(title, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
      ),

      Text(':', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
      const SizedBox(width: Dimensions.paddingSizeSmall),
      
      Expanded(
        flex: ResponsiveHelper.isDesktop(context) ? 4 : 1,
        child: Text(value, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
      ),
      
    ]);
  }
}

