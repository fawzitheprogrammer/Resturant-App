import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdateScreen extends StatelessWidget {
  final bool isUpdate;
  const UpdateScreen({super.key, required this.isUpdate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

            Image.asset(
              isUpdate ? Images.update : Images.maintenance,
              width: MediaQuery.of(context).size.height*0.4,
              height: MediaQuery.of(context).size.height*0.4,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.01),

            Text(
              isUpdate ? 'update'.tr : 'we_are_under_maintenance'.tr,
              style: robotoBold.copyWith(fontSize: MediaQuery.of(context).size.height*0.023, color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.01),

            Text(
              isUpdate ? 'your_app_is_deprecated'.tr : 'we_will_be_right_back'.tr,
              style: robotoRegular.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: Theme.of(context).disabledColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isUpdate ? MediaQuery.of(context).size.height*0.04 : 0),

            isUpdate ? CustomButtonWidget(buttonText: 'update_now'.tr, onPressed: () async {
              String? appUrl = 'https://google.com';
              if(GetPlatform.isAndroid) {
                appUrl = Get.find<SplashController>().configModel!.appUrlAndroid;
              }else if(GetPlatform.isIOS) {
                appUrl = Get.find<SplashController>().configModel!.appUrlIos;
              }
              if(await canLaunchUrlString(appUrl!)) {
                launchUrlString(appUrl, mode: LaunchMode.externalApplication);
              }else {
                showCustomSnackBar('${'can_not_launch'.tr} $appUrl');
              }
            }) : const SizedBox(),

          ]),
        ),
      ),
    );
  }
}
