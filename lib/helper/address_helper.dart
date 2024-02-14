import 'dart:convert';

import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/address/domain/models/address_model.dart';
import '../util/app_constants.dart';

class AddressHelper {
  static Future<bool> saveAddressInSharedPref(AddressModel address) async {
    SharedPreferences sharedPreferences = Get.find<SharedPreferences>();
    String userAddress = jsonEncode(address.toJson());
    Get.find<ApiClient>().updateHeader(
      sharedPreferences.getString(AppConstants.token),
      address.zoneIds,
      sharedPreferences.getString(AppConstants.languageCode),
      address.latitude,
      address.longitude,
    );
    return await sharedPreferences.setString(AppConstants.userAddress, userAddress);
  }

  static AddressModel? getAddressFromSharedPref() {
    SharedPreferences sharedPreferences = Get.find<SharedPreferences>();
    AddressModel? addressModel;
    try {
      addressModel = AddressModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!));
    } catch (e) {
      debugPrint('Catch exception : $e');
    }
    return addressModel;
  }

  static bool clearAddressFromSharedPref() {
    SharedPreferences sharedPreferences = Get.find<SharedPreferences>();
    sharedPreferences.remove(AppConstants.userAddress);
    return true;
  }

}
