import 'package:stackfood_multivendor/features/checkout/widgets/custom_date_picker.dart';
import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_cancellation_body.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class SubscriptionPauseDialog extends StatefulWidget {
  final int? subscriptionID;
  final bool isPause;
  const SubscriptionPauseDialog({super.key, required this.subscriptionID, required this.isPause});

  @override
  State<SubscriptionPauseDialog> createState() => _SubscriptionPauseDialogState();
}

class _SubscriptionPauseDialogState extends State<SubscriptionPauseDialog> {
  DateTimeRange? _range;
  final TextEditingController _noteController = TextEditingController();
  final List<DropdownMenuItem<int>> _cancelReasons = [];
  final List<CancellationData> _reasons = [];
  @override
  void initState() {
    super.initState();


    if(Get.find<OrderController>().orderCancelReasons != null && Get.find<OrderController>().orderCancelReasons!.isNotEmpty){

      _reasons.add(CancellationData(reason: 'select_cancel_reason'.tr));
      for (var reason in Get.find<OrderController>().orderCancelReasons!) {
        _reasons.add(reason);
      }

      for(int index=0; index < _reasons.length; index++){
        _cancelReasons.add(DropdownMenuItem<int>(value: index, child: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: SizedBox(
              height: 30 ,
              child: Center(child: Text(_reasons[index].reason!, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)))),
        ),
        ));
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: PointerInterceptor(
        child: SizedBox(width: 500, child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: SingleChildScrollView(
            child: GetBuilder<OrderController>(
              builder: (orderController) {
                return Column(mainAxisSize: MainAxisSize.min, children: [

                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Image.asset(Images.warning, width: 50, height: 50, color: Theme.of(context).primaryColor),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Text(
                      widget.isPause ? 'are_you_sure_to_pause_subscription'.tr : 'are_you_sure_to_cancel_subscription'.tr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  !widget.isPause
                      ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        border: Border.all(
                          color: Theme.of(context).textTheme.bodyLarge!.color!, width: 0.5,
                       )
                    ),
                        child: DropdownButton(
                          value: orderController.cancellationIndex,
                            items: _cancelReasons,
                            itemHeight: 50,
                            underline: const SizedBox(),
                            onChanged: (int? index){
                              orderController.setCancelIndex(index);
                              orderController.setOrderCancelReason(_reasons[index!].reason);
                            },
                        ),
                      ) : const SizedBox(),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  widget.isPause ? CustomDatePicker(
                    hint: 'choose_subscription_pause_date'.tr,
                    range: _range,
                    isPause: widget.isPause,
                    onDatePicked: (DateTimeRange range) {
                      setState(() {
                        _range = range;
                      });
                    },
                  ) : CustomTextFieldWidget(
                    hintText: 'write_cancellation_reason'.tr,
                    controller: _noteController,
                    maxLines: 3,
                    inputType: TextInputType.multiline,
                    inputAction: TextInputAction.newline,
                   // fillColor: Theme.of(context).disabledColor.withOpacity(0.1),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  GetBuilder<OrderController>(builder: (orderController) {
                    return !orderController.subscriveLoading ? Row(children: [
                      Expanded(child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), minimumSize: const Size(Dimensions.webMaxWidth, 50), padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                        ),
                        child: Text(
                          'no'.tr, textAlign: TextAlign.center,
                          style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                        ),
                      )),
                      const SizedBox(width: Dimensions.paddingSizeLarge),

                      Expanded(child: CustomButtonWidget(
                        buttonText: 'yes'.tr,
                        onPressed: () {
                          if(widget.isPause && _range == null) {
                            showCustomSnackBar('choose_subscription_pause_date'.tr);
                          }else if(!widget.isPause && orderController.cancellationIndex == 0) {
                            showCustomSnackBar('please_select_cancellation_reason_first'.tr);
                          }else {
                            orderController.updateSubscriptionStatus(
                              widget.subscriptionID, _range?.start, _range?.end,
                              widget.isPause ? 'paused' : 'canceled', _noteController.text.trim(), _reasons[orderController.cancellationIndex!].reason,
                            );
                          }
                        },
                        radius: Dimensions.radiusSmall, height: 50,
                      )),
                    ]) : const Center(child: CircularProgressIndicator());
                  }),

                ]);
              }
            ),
          ),
        )),
      ),
    );
  }
}
