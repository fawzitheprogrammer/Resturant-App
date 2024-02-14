import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/business/controllers/business_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessPaymentMethodBottomSheetWidget extends StatefulWidget {
  const BusinessPaymentMethodBottomSheetWidget({super.key});

  @override
  State<BusinessPaymentMethodBottomSheetWidget> createState() => _PaymentMethodBottomSheetState();
}

class _PaymentMethodBottomSheetState extends State<BusinessPaymentMethodBottomSheetWidget> {

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 550,
      child: GetBuilder<BusinessController>(builder: (businessController) {
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

                    Row(children: [
                      Text('pay_via_online'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      Text(
                        'faster_and_secure_way_to_pay_bill'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                      ),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    ListView.builder(
                        itemCount: Get.find<SplashController>().configModel!.activePaymentMethodList!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index){
                          bool isSelected = businessController.paymentIndex == 1 && Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay! == businessController.digitalPaymentName;

                          return InkWell(
                            onTap: (){
                              businessController.setPaymentIndex(1);
                              businessController.changeDigitalPaymentName(Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay!);
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
                        }),

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
      }),
    );
  }
}
