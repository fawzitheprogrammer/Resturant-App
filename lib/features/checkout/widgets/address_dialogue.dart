import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/address/widgets/address_card_widget.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressDialogue extends StatelessWidget {
  final List<AddressModel?> addressList;
  final TextEditingController? streetNumberController;
  final TextEditingController? houseController;
  final TextEditingController? floorController;
  const AddressDialogue({super.key, required this.addressList, this.streetNumberController, this.houseController, this.floorController});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        width: 500,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeExtraSmall),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Text('select_a_address'.tr),
                  InkWell(onTap: () => Get.back(), child: const Icon(Icons.clear)),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                  itemCount: addressList.length,
                  itemBuilder: (context, index){
                    return AddressCardWidget(onTap: (){
                      Get.find<CheckoutController>().getDistanceInKM(
                        LatLng(
                          double.parse(addressList[index]!.latitude!),
                          double.parse(addressList[index]!.longitude!),
                        ),
                        LatLng(
                          double.parse(Get.find<RestaurantController>().restaurant!.latitude!),
                          double.parse(Get.find<RestaurantController>().restaurant!.longitude!),
                        ),
                      );
                      Get.find<CheckoutController>().setAddressIndex(index);
                      streetNumberController!.text = addressList[index]!.road ?? '';
                      houseController!.text = addressList[index]!.house ?? '';
                      floorController!.text = addressList[index]!.floor ?? '';

                      Get.back();
                    }, address: addressList[index], fromAddress: false, fromCheckout: true);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
