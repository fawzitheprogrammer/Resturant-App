
import 'package:country_code_picker/country_code_picker.dart';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GuestDeliveryAddress extends StatelessWidget {
  final CheckoutController checkoutController;
  final TextEditingController guestNameTextEditingController;
  final TextEditingController guestNumberTextEditingController;
  final TextEditingController guestEmailController;
  final FocusNode guestNumberNode;
  final FocusNode guestEmailNode;

  const GuestDeliveryAddress({super.key, required this.checkoutController,
    required this.guestNameTextEditingController, required this.guestNumberTextEditingController,
    required this.guestNumberNode, required this.guestEmailController, required this.guestEmailNode});

  @override
  Widget build(BuildContext context) {
    bool takeAway = (checkoutController.orderType == 'take_away');
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    AddressModel address = AddressHelper.getAddressFromSharedPref()!;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : Dimensions.fontSizeDefault),
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, spreadRadius: 1, offset: const Offset(1, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(takeAway ? 'contact_information'.tr : 'deliver_to'.tr, style: robotoMedium),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2)),
          ),
          child: takeAway ? Column(children: [

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(children: [
                CustomTextFieldWidget(
                  showTitle: true,
                  titleText: 'contact_person_name'.tr,
                  hintText: ' ',
                  inputType: TextInputType.name,
                  controller: guestNameTextEditingController,
                  nextFocus: guestNumberNode,
                  capitalization: TextCapitalization.words,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                CustomTextFieldWidget(
                  showTitle: true,
                  titleText: 'contact_person_number'.tr,
                  hintText: ' ',
                  controller: guestNumberTextEditingController,
                  focusNode: guestNumberNode,
                  nextFocus: guestEmailNode,
                  inputType: TextInputType.phone,
                  isPhone: true,
                  onCountryChanged: (CountryCode countryCode) {
                    checkoutController.countryDialCode = countryCode.dialCode;
                  },
                  countryDialCode: checkoutController.countryDialCode ?? Get.find<LocalizationController>().locale.countryCode,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                CustomTextFieldWidget(
                  showTitle: true,
                  titleText: 'email'.tr,
                  hintText: ' ',
                  controller: guestEmailController,
                  focusNode: guestEmailNode,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.emailAddress,
                ),

              ]),
            ),
          ]) : Column(crossAxisAlignment: CrossAxisAlignment.start,  children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Row(children: [
                checkoutController.guestAddress == null ? Flexible(
                  child: Row(
                    children: [
                      Text(
                        "no_contact_information_added".tr,
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error)
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      InkWell(
                        onTap: () async {},
                        child: Icon(Icons.info_outlined, color: Theme.of(context).colorScheme.error, size: 15),
                      ),

                      const Spacer(),
                    ],
                  ),
                ) : Flexible(
                  child: Row(children: [

                    Flexible(
                      flex: 4,
                      child: Row(children: [
                        Icon(Icons.person, color: Theme.of(context).disabledColor, size: 20),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Flexible(
                          child: Text(
                            checkoutController.guestAddress!.contactPersonName!,
                            style: robotoBold,
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Flexible(
                      flex: 6,
                      child: Row(children: [
                        Icon(Icons.phone, color: Theme.of(context).disabledColor, size: 20),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Flexible(
                          child: Text(
                            checkoutController.guestAddress!.contactPersonNumber!,
                            style: robotoBold,
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                  ]),
                ),

                takeAway ? const SizedBox() : InkWell(
                  onTap: () async {
                    var address = await Get.toNamed(RouteHelper.getEditAddressRoute(checkoutController.guestAddress, fromGuest: true));
                    if(address != null) {
                      checkoutController.setGuestAddress(address);
                      checkoutController.getDistanceInKM(
                        LatLng(double.parse(address.latitude), double.parse(address.longitude)),
                        LatLng(double.parse(checkoutController.restaurant!.latitude!), double.parse(checkoutController.restaurant!.longitude!)),
                      );
                    }
                  },
                  child: Image.asset(Images.editDelivery, height: 20, width: 20, color: Theme.of(context).primaryColor),
                ),
              ]),
            ),

            const Divider(),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  checkoutController.guestAddress == null ? address.address! : checkoutController.guestAddress!.address!,
                  style: robotoRegular,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                checkoutController.guestAddress == null ? const SizedBox() : const SizedBox(height: Dimensions.paddingSizeSmall),

                (checkoutController.guestAddress != null && checkoutController.guestAddress!.email != null) ? Row(children: [
                  Text('${'email'.tr} - ', style: robotoRegular.copyWith(color: Theme.of(Get.context!).disabledColor)),
                  Flexible(child: Text(checkoutController.guestAddress!.email ?? '', style: robotoRegular, maxLines: 1, overflow: TextOverflow.ellipsis)),
                ]) : const SizedBox(),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                
                checkoutController.guestAddress == null ? const SizedBox() : Row(children: [
                  checkoutController.guestAddress!.house != null ? Flexible(
                    child: Row(children: [
                      Text('${'house'.tr} - ', style: robotoRegular.copyWith(color: Theme.of(Get.context!).disabledColor)),
                      Flexible(child: Text(checkoutController.guestAddress!.house ?? '', style: robotoRegular, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ]),
                  ) : const SizedBox(),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  checkoutController.guestAddress!.floor != null ? Flexible(
                    child: Row(children: [
                      Text('${'floor'.tr} - ', style: robotoRegular.copyWith(color: Theme.of(Get.context!).disabledColor)),
                      Flexible(child: Text(checkoutController.guestAddress!.floor ?? '', style: robotoRegular, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ]),
                  ) : const SizedBox(),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                ]),
              ]),
            ),
          ]),
        ),

      ]),
    );
  }
}
