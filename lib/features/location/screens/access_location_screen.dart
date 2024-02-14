import 'package:stackfood_multivendor/common/widgets/custom_loader_widget.dart';
import 'package:stackfood_multivendor/features/address/controllers/address_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/address/widgets/address_card_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/features/location/widgets/bottom_button.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccessLocationScreen extends StatelessWidget {
  final bool fromSignUp;
  final bool fromHome;
  final String? route;
  const AccessLocationScreen({super.key, required this.fromSignUp, required this.fromHome, required this.route});

  @override
  Widget build(BuildContext context) {
    if(!fromHome && AddressHelper.getAddressFromSharedPref() != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.dialog(const CustomLoaderWidget(), barrierDismissible: false);
        Get.find<LocationController>().autoNavigate(
          AddressHelper.getAddressFromSharedPref()!, fromSignUp, route, route != null, ResponsiveHelper.isDesktop(Get.context),
        );
      });
    }
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(isLoggedIn) {
      Get.find<AddressController>().getAddressList();
    }

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'set_location'.tr, isBackButtonExist: fromHome),
      endDrawer: const MenuDrawerWidget(),endDrawerEnableOpenDragGesture: false,
      body: SafeArea(child: GetBuilder<AddressController>(builder: (addressController) {
        return isLoggedIn ? SingleChildScrollView(
          child: FooterViewWidget(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

              addressController.addressList != null ? addressController.addressList!.isNotEmpty ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: addressController.addressList!.length,
                padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeSmall) : const EdgeInsets.all(Dimensions.paddingSizeDefault),
                itemBuilder: (context, index) {
                  return Center(child: SizedBox(width: 700, child: AddressCardWidget(
                    address: addressController.addressList![index],
                    fromAddress: false,
                    onTap: () {
                      Get.dialog(const CustomLoaderWidget(), barrierDismissible: false);
                      AddressModel address = addressController.addressList![index];
                      Get.find<LocationController>().saveAddressAndNavigate(address, fromSignUp, route, route != null, ResponsiveHelper.isDesktop(Get.context));
                    },
                  )));
                },
              ) : NoDataScreen(title: 'no_saved_address_found'.tr) : const Center(child: CircularProgressIndicator()),
              SizedBox(height: (addressController.addressList != null && addressController.addressList!.length < 4) ? 200 : Dimensions.paddingSizeLarge),

              ResponsiveHelper.isDesktop(context) ? BottomButton(addressController: addressController, fromSignUp: fromSignUp, route: route) : const SizedBox(),

            ]),
          ),
        ) : Center(child: SingleChildScrollView(
          child: FooterViewWidget(
            child: Center(child: Padding(
              padding: context.width > 700 ? const EdgeInsets.all(50) : EdgeInsets.zero,
              child: SizedBox(width: 700, child: Column(children: [
                Image.asset(Images.deliveryLocation, height: 220),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                Text(
                  'find_restaurants_and_foods'.tr.toUpperCase(), textAlign: TextAlign.center,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                ),
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Text(
                    'by_allowing_location_access'.tr, textAlign: TextAlign.center,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                BottomButton(addressController: addressController, fromSignUp: fromSignUp, route: route),
              ])),
            )),
          ),
        ));
      })),
      bottomNavigationBar: !ResponsiveHelper.isDesktop(context) && isLoggedIn ? GetBuilder<AddressController>(
        builder: (addressController) {
          return SizedBox(height: context.height * 0.24, child: BottomButton(addressController: addressController, fromSignUp: fromSignUp, route: route));
        }
      ) : const SizedBox(),
    );
  }
}

