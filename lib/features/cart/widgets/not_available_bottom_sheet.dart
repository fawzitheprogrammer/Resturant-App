import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotAvailableBottomSheet extends StatelessWidget {
  const NotAvailableBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isMobile(context) ? const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge))
            : const BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
        child: Column(children: [
          Container(
            height: 4, width: 35,
            margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(10)),
          ),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('if_any_product_is_not_available'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
            IconButton(
              onPressed: ()=> Get.back(),
              icon: Icon(Icons.clear, color: Theme.of(context).disabledColor),
            )
          ]),

          GetBuilder<CartController>(
            builder: (cartController) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartController.notAvailableList.length,
                  itemBuilder: (context, index){
                return InkWell(
                  onTap: () => cartController.setAvailableIndex(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cartController.notAvailableIndex == index ? Theme.of(context).primaryColor.withOpacity(0.5) : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      border: Border.all(color: cartController.notAvailableIndex == index ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 0.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                    margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                    child: Text(
                      cartController.notAvailableList[index].tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: cartController.notAvailableIndex == index ? Theme.of(context).cardColor : Theme.of(context).disabledColor),
                    ),
                  ),
                );
              });
            }
          ),

          GetBuilder<CartController>(
            builder: (cartController) {
              return SafeArea(
                child: CustomButtonWidget(
                  buttonText: 'apply'.tr,
                  onPressed: cartController.notAvailableIndex == -1 ? null : (){
                   Get.back();
                  },
                ),
              );
            }
          ),

          const SizedBox(height: Dimensions.paddingSizeLarge)
        ]),
      ),
    );
  }
}
