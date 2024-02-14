import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfflineSuccessDialog extends StatelessWidget {
  final int? orderId;
  const OfflineSuccessDialog({super.key, required this.orderId, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 500,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          ),
          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
          child: SingleChildScrollView(
            child: Column(children: [
              const Icon(Icons.check_circle, size: 60, color: Colors.green),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text(
                'order_placed_successfully'.tr ,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              RichText(textAlign: TextAlign.center, text: TextSpan(children: [
                TextSpan(text: 'your_payment_has_been_successfully_processed_and_your_order'.tr, style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.4))),
                TextSpan(text: ' #$orderId ', style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                TextSpan(text: 'has_been_placed'.tr, style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.4))),
              ])),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              GetBuilder<OrderController>(
                  builder: (orderController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2)),
                      ),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: orderController.trackModel != null ? ListView.builder(
                          itemCount: orderController.trackModel!.offlinePayment!.input!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index){
                            Input data = orderController.trackModel!.offlinePayment!.input![index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                              child: Row(children: [

                                Expanded(child: Text(data.userInput.toString().replaceAll('_', ' '), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall))),

                                Text(':', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                Expanded(child: Text(data.userData.toString(), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall))),

                              ]),
                            );
                          }) : const SizedBox(),
                    );
                  }
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              RichText(textAlign: TextAlign.center, text: TextSpan(children: [
                TextSpan(text: '*', style: robotoMedium.copyWith(color: Colors.red)),
                TextSpan(text: 'offline_order_note'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
              ])),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              CustomButtonWidget(
                width: 100,
                color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
                buttonText: 'ok'.tr,
                onPressed: () {
                  Get.back();
                },
              )

            ]),
          ),
        ),
      ),
    );
  }
}
