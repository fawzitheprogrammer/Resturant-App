import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/features/address/controllers/address_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/address/domain/reposotories/address_repo_interface.dart';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:get/get.dart';

import 'address_service_interface.dart';

class AddressService implements AddressServiceInterface{
  final AddressRepoInterface addressRepoInterface;
  AddressService({required this.addressRepoInterface});

  @override
  List<AddressModel> filterAddresses(List<AddressModel> addresses, String queryText) {
    List<AddressModel> addressList = [];
    if (queryText.isEmpty) {
      addressList.addAll(addresses);
    } else {
      for (var address in addresses) {
        if (address.address!.toLowerCase().contains(queryText.toLowerCase())) {
          addressList.add(address);
        }
      }
    }
    return addressList;
  }

  @override
  Future<List<AddressModel>?> getList({bool isLocal = false}) async {
    return await addressRepoInterface.getList();
  }

  @override
  Future<ResponseModel> add(AddressModel addressModel, bool fromCheckout, int? restaurantZoneId) async {
    ResponseModel responseModel = await addressRepoInterface.add(addressModel);
    if(fromCheckout && !responseModel.zoneIds!.contains(restaurantZoneId)) {
      responseModel = ResponseModel(false, 'your_selected_location_is_from_different_zone'.tr);
    }
    if (responseModel.isSuccess) {
      Get.find<AddressController>().getAddressList();
      Get.find<CheckoutController>().setAddressIndex(0);
    }
    return responseModel;
  }

  @override
  Future<ResponseModel> delete(int id) async {
    return await addressRepoInterface.delete(id);
  }

  @override
  Future<ResponseModel> update(Map<String, dynamic> body, int? addressId) async {
    return await addressRepoInterface.update(body, addressId!);
  }

}