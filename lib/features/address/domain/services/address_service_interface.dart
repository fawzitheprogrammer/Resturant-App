import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';

abstract class AddressServiceInterface{
  Future<List<AddressModel>?> getList({bool isLocal = false});
  Future<ResponseModel> add(AddressModel addressModel, bool fromCheckout, int? restaurantZoneId);
  Future<ResponseModel> update(Map<String, dynamic> body, int? addressId);
  Future<ResponseModel> delete(int id);
  List<AddressModel> filterAddresses(List<AddressModel> addresses, String queryText);
}