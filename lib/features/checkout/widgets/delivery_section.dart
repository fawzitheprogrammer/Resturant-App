import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/address/widgets/address_card_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/guest_delivery_address.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/features/location/widgets/permission_dialog.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_dropdown_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliverySection extends StatelessWidget {
  final CheckoutController checkoutController;
  final LocationController locationController;
  final TextEditingController guestNameTextEditingController;
  final TextEditingController guestNumberTextEditingController;
  final TextEditingController guestEmailController;
  final FocusNode guestNumberNode;
  final FocusNode guestEmailNode;
  const DeliverySection({super.key, required this.checkoutController,
    required this.locationController, required this.guestNameTextEditingController,
    required this.guestNumberTextEditingController, required this.guestNumberNode, required this.guestEmailController, required this.guestEmailNode});

  @override
  Widget build(BuildContext context) {
    bool isGuestLoggedIn = Get.find<AuthController>().isGuestLoggedIn();
    bool takeAway = (checkoutController.orderType == 'take_away');
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    GlobalKey<CustomDropdownState> dropDownKey = GlobalKey<CustomDropdownState>();
    AddressModel addressModel;

    return Column(children: [
      isGuestLoggedIn  ? GuestDeliveryAddress(
        checkoutController: checkoutController, guestNumberNode: guestNumberNode,
        guestNameTextEditingController: guestNameTextEditingController,
        guestNumberTextEditingController: guestNumberTextEditingController,
        guestEmailController: guestEmailController, guestEmailNode: guestEmailNode,
      ) : !takeAway ? Container(
        margin: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : Dimensions.fontSizeDefault),
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, spreadRadius: 1, offset: const Offset(1, 2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('deliver_to'.tr, style: robotoMedium),
            InkWell(
              onTap: () async{
                dropDownKey.currentState?.toggleDropdown();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall),
                child: Icon(Icons.arrow_drop_down, size: 34, color: Theme.of(context).primaryColor),
              ),
            ),
          ]),


          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Colors.transparent,
                border: Border.all(color: Colors.transparent)
            ),
            child: CustomDropdown<int>(
              key: dropDownKey,
              hideIcon: true,
              onChange: (int? value, int index) async {

                if(value == -1) {
                  var address = await Get.toNamed(RouteHelper.getAddAddressRoute(true, checkoutController.restaurant!.zoneId));
                  if(address != null) {

                    checkoutController.insertAddresses(Get.context!, address, notify: true);

                    checkoutController.streetNumberController.text = address.road ?? '';
                    checkoutController.houseController.text = address.house ?? '';
                    checkoutController.floorController.text = address.floor ?? '';

                    checkoutController.getDistanceInKM(
                      LatLng(double.parse(address.latitude), double.parse(address.longitude )),
                      LatLng(double.parse(checkoutController.restaurant!.latitude!), double.parse(checkoutController.restaurant!.longitude!)),
                    );
                  }
                } else if(value == -2) {
                  _checkPermission(() async {
                    addressModel = await locationController.getCurrentLocation(true, mapController: null, showSnackBar: true);

                    if(addressModel.zoneIds!.isNotEmpty) {

                      checkoutController.insertAddresses(Get.context!, addressModel, notify: true);

                      checkoutController.getDistanceInKM(
                        LatLng(
                          locationController.position.latitude, locationController.position.longitude,
                        ),
                        LatLng(double.parse(checkoutController.restaurant!.latitude!), double.parse(checkoutController.restaurant!.longitude!)),
                      );
                    }
                  });

                } else{
                  checkoutController.getDistanceInKM(
                    LatLng(
                      double.parse(checkoutController.address[value!].latitude!),
                      double.parse(checkoutController.address[value].longitude!),
                    ),
                    LatLng(double.parse(checkoutController.restaurant!.latitude!), double.parse(checkoutController.restaurant!.longitude!)),
                  );
                  checkoutController.setAddressIndex(value);

                  checkoutController.streetNumberController.text = checkoutController.address[value].road ?? '';
                  checkoutController.houseController.text = checkoutController.address[value].house ?? '';
                  checkoutController.floorController.text = checkoutController.address[value].floor ?? '';
                }

              },
              dropdownButtonStyle: DropdownButtonStyle(
                height: 0, width: double.infinity,
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
              ),
              dropdownStyle: DropdownStyle(
                elevation: 10,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              ),
              items: checkoutController.addressList,
              child: const SizedBox(),

            ),
          ),
          Container(
            constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? 90 : 75),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                border: Border.all(color: Theme.of(context).primaryColor)
            ),
            child: AddressCardWidget(
              address: (checkoutController.address.length-1) >= checkoutController.addressIndex ? checkoutController.address[checkoutController.addressIndex] : checkoutController.address[0],
              fromAddress: false, fromCheckout: true,
            ),
          ),

          SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeDefault),

          !ResponsiveHelper.isDesktop(context) ? CustomTextFieldWidget(
            titleText: 'street_number'.tr,
            inputType: TextInputType.streetAddress,
            focusNode: checkoutController.streetNode,
            nextFocus: checkoutController.houseNode,
            controller: checkoutController.streetNumberController,
          ) : const SizedBox(),
          SizedBox(height: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),

          Row(
            children: [
              ResponsiveHelper.isDesktop(context) ? Expanded(
                child: CustomTextFieldWidget(
                  titleText: 'street_number'.tr,
                  inputType: TextInputType.streetAddress,
                  focusNode: checkoutController.streetNode,
                  nextFocus: checkoutController.houseNode,
                  controller: checkoutController.streetNumberController,
                  showTitle: ResponsiveHelper.isDesktop(context),
                ),
              ) : const SizedBox(),
              SizedBox(width: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0),

              Expanded(
                child: CustomTextFieldWidget(
                  titleText: 'house'.tr,
                  inputType: TextInputType.text,
                  focusNode: checkoutController.houseNode,
                  nextFocus: checkoutController.floorNode,
                  controller: checkoutController.houseController,
                  showTitle: ResponsiveHelper.isDesktop(context),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: CustomTextFieldWidget(
                  titleText: 'floor'.tr,
                  inputType: TextInputType.text,
                  focusNode: checkoutController.floorNode,
                  inputAction: TextInputAction.done,
                  controller: checkoutController.floorController,
                  showTitle: ResponsiveHelper.isDesktop(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        ]),
      ) : const SizedBox(),
    ]);
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
    }else {
      onTap();
    }
  }
}
