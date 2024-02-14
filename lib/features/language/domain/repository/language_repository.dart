import 'dart:convert';

import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/language/domain/repository/language_repository_interface.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageRepository implements LanguageRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LanguageRepository({required this.apiClient, required this.sharedPreferences});

  @override
  AddressModel? getAddressFormSharedPref() {
    AddressModel? addressModel;
    try {
      addressModel = AddressModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!));
    }catch(e) {
      debugPrint('Did not get shared Preferences address . Note: $e');
    }
    return addressModel;
  }

  @override
  void updateHeader(AddressModel? addressModel, Locale locale) {
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token), addressModel?.zoneIds,
      locale.languageCode, addressModel?.latitude,
      addressModel?.longitude,
    );
  }

  @override
  Locale getLocaleFromSharedPref() {
    return Locale(sharedPreferences.getString(AppConstants.languageCode) ?? AppConstants.languages[0].languageCode!,
        sharedPreferences.getString(AppConstants.countryCode) ?? AppConstants.languages[0].countryCode);
  }

  @override
  void saveLanguage(Locale locale) {
    sharedPreferences.setString(AppConstants.languageCode, locale.languageCode);
    sharedPreferences.setString(AppConstants.countryCode, locale.countryCode!);
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}