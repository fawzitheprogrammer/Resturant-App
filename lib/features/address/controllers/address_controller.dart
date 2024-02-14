import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/address/domain/services/address_service_interface.dart';
import 'package:get/get.dart';

class AddressController extends GetxController implements GetxService {
  final AddressServiceInterface addressServiceInterface;
  AddressController({required this.addressServiceInterface});

  List<AddressModel>? _addressList;
  late List<AddressModel> _allAddressList;
  List<AddressModel>? get addressList => _addressList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> deleteAddress(int? id, int index) async {
    ResponseModel responseModel = await addressServiceInterface.delete(id!);
    if (responseModel.isSuccess) {
      _addressList!.removeAt(index);
    }
    update();
    return responseModel;
  }

  Future<void> getAddressList({bool canInsertAddress = false}) async {
    List<AddressModel>? addressList = await addressServiceInterface.getList();
    if (addressList != null) {
      _addressList = [];
      _allAddressList = [];
      _addressList?.addAll(addressList);
      _allAddressList.addAll(addressList);
      if (canInsertAddress) {
        Get.find<CheckoutController>().insertAddresses(Get.context!, null);
      }
    }
    update();
  }

  Future<ResponseModel> addAddress(AddressModel addressModel, bool fromCheckout, int? restaurantZoneId) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await addressServiceInterface.add(addressModel, fromCheckout, restaurantZoneId);
    _isLoading = false;
    update();
    return responseModel;
  }

  // Future<bool> saveAddressLocally(AddressModel address) async {
  //   ResponseModel responseModel = await addressService.add(address);
  //   return responseModel.isSuccess;
  // }

  void filterAddresses(String queryText) {
    if (_addressList != null) {
      _addressList = addressServiceInterface.filterAddresses(_addressList!, queryText);
      update();
    }
  }

  Future<ResponseModel> updateAddress(AddressModel addressModel, int? addressId) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await addressServiceInterface.update(addressModel.toJson(), addressId!);
    if (responseModel.isSuccess) {
      Get.find<AddressController>().getAddressList();
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}
