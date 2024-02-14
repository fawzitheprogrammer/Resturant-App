import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/cart/widgets/not_available_bottom_sheet.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class NotAvailableProductViewWidget extends StatelessWidget {
  final CartController cartController;
  const NotAvailableProductViewWidget({super.key, required this.cartController});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: Theme.of(context).primaryColor, width: 0.5),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: (){
              if(isDesktop){
                Get.dialog(const Dialog(child: NotAvailableBottomSheet()));
              }else{
                showModalBottomSheet(
                  context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                  builder: (con) => const NotAvailableBottomSheet(),
                );
              }
            },
            child: Row(children: [
              Expanded(child: Text('if_any_product_is_not_available'.tr, style: robotoMedium, maxLines: 2, overflow: TextOverflow.ellipsis)),
              const Icon(Icons.arrow_forward_ios_sharp, size: 18),
            ]),
          ),


          cartController.notAvailableIndex != -1 ? Row(children: [
            Text(cartController.notAvailableList[cartController.notAvailableIndex].tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)),

            IconButton(
              onPressed: ()=> cartController.setAvailableIndex(-1),
              icon: const Icon(Icons.clear, size: 18),
            )
          ]) : const SizedBox(),
        ],
      ),
    );
  }
}
