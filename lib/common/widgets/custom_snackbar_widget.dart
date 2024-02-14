import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String? message, {bool isError = true, showToaster = false}) {
  if(message != null && message.isNotEmpty) {

    if(showToaster && !GetPlatform.isWeb){
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: isError ? Colors.red : Colors.green,
          textColor: Colors.white,
          fontSize: Dimensions.fontSizeDefault,
      );
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.only(
          right: ResponsiveHelper.isDesktop(Get.context) ? Get.context!.width*0.7 : Dimensions.paddingSizeSmall,
          top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall,
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        content: Text(message, style: robotoMedium.copyWith(color: Colors.white)),
      ));
    }

  }
}