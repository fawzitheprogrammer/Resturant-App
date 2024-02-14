import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/product/controllers/product_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VegFilterWidget extends StatelessWidget {
  final String? type;
  final bool fromAppBar;
  final Function(String value)? onSelected;
  const VegFilterWidget({super.key, required this.type, required this.onSelected, this.fromAppBar = false});


  @override
  Widget build(BuildContext context) {
    final bool ltr = Get.find<LocalizationController>().isLtr;
    List<PopupMenuEntry> entryList = _generateProductTypeList(Get.find<ProductController>().productTypeList, context);

    return Get.find<SplashController>().configModel!.toggleVegNonVeg! ? Padding(
      padding: fromAppBar ? EdgeInsets.zero : EdgeInsets.only(left: ltr ? Dimensions.paddingSizeSmall : 0, right: ltr ? 0 : Dimensions.paddingSizeSmall),
      child: PopupMenuButton<dynamic>(
        offset: const Offset(-20, 20),
        itemBuilder: (BuildContext context) => entryList,
        onSelected: (dynamic value) => onSelected!(Get.find<ProductController>().productTypeList[value]),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
        ),
        child: Container(
          decoration: fromAppBar ? const BoxDecoration() : BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color: Theme.of(context).cardColor,
              border: Border.all(color: Theme.of(context).primaryColor, width: 0.5)
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          child: Icon(Icons.tune_sharp, size: 24, color: Theme.of(context).primaryColor),
        ),
      ),
    ) : const SizedBox();
  }

  List<PopupMenuEntry> _generateProductTypeList(List<String> productTypeList, BuildContext context) {
    List<PopupMenuEntry> entryList = [];
    for(int i=0; i < productTypeList.length; i++){
      entryList.add(PopupMenuItem<int>(value: i, child: Row(children: [
        productTypeList[i] == type
            ? Icon(Icons.radio_button_checked_sharp, color: Theme.of(context).primaryColor)
            : Icon(Icons.radio_button_off, color: Theme.of(context).disabledColor),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

        Text(
          productTypeList[i].tr,
          style: robotoMedium.copyWith(color: Get.find<ProductController>().productTypeList[i] == type
              ? Theme.of(context).textTheme.bodyMedium!.color : Theme.of(context).disabledColor),
        ),
      ])));
    }
    return entryList;
  }
}
