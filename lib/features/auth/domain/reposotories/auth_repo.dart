import 'dart:convert';

import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/signup_body_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/social_log_in_body_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/reposotories/auth_repo_interface.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo implements AuthRepoInterface<SignUpBodyModel> {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({ required this.sharedPreferences, required this.apiClient});

  @override
  Future<bool> saveUserToken(String token, {bool alreadyInApp = false}) async {
    apiClient.token = token;
    if(alreadyInApp && sharedPreferences.getString(AppConstants.userAddress) != null){
      AddressModel? addressModel = AddressModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!));
      apiClient.updateHeader(
        token, addressModel.zoneIds, sharedPreferences.getString(AppConstants.languageCode),
        addressModel.latitude, addressModel.longitude,
      );
    }else{
      apiClient.updateHeader(token, null, sharedPreferences.getString(AppConstants.languageCode), null, null);
    }

    return await sharedPreferences.setString(AppConstants.token, token);
  }

  @override
  Future<Response> updateToken({String notificationDeviceToken = ''}) async {
    String? deviceToken;
    if(notificationDeviceToken.isEmpty){
      if (GetPlatform.isIOS && !GetPlatform.isWeb) {
        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
        NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
          alert: true, announcement: false, badge: true, carPlay: false,
          criticalAlert: false, provisional: false, sound: true,
        );
        if(settings.authorizationStatus == AuthorizationStatus.authorized) {
          deviceToken = await _saveDeviceToken();
        }
      }else {
        deviceToken = await _saveDeviceToken();
      }
      if(!GetPlatform.isWeb) {
        FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
      }
    }
    return await apiClient.postData(AppConstants.tokenUri, {"_method": "put", "cm_firebase_token": notificationDeviceToken.isNotEmpty ? notificationDeviceToken : deviceToken});
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '@';
    if(!GetPlatform.isWeb) {
      try {
        deviceToken = (await FirebaseMessaging.instance.getToken())!;
      }catch(_) {}
    }
    if (deviceToken != null) {
      debugPrint('--------Device Token---------- $deviceToken');
    }
    return deviceToken;
  }

  @override
  Future<Response> registration(SignUpBodyModel signUpModel) async {
    return await apiClient.postData(AppConstants.registerUri, signUpModel.toJson(), handleError: false);
  }

  @override
  Future<Response> login({String? phone, String? password}) async {
    String guestId = getGuestId();
    Map<String, String> data = {
      "phone": phone!,
      "password": password!,
    };
    if(guestId.isNotEmpty) {
      data.addAll({"guest_id": guestId});
    }
    return await apiClient.postData(AppConstants.loginUri, data, handleError: false);

  }

  @override
  Future<ResponseModel> guestLogin() async {
    Response response = await apiClient.postData(AppConstants.guestLoginUri, {}, handleError: false);
    if (response.statusCode == 200) {
      saveGuestId(response.body['guest_id'].toString());
      return ResponseModel(true, '${response.body['guest_id']}');
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<bool> saveGuestId(String id) async {
    return await sharedPreferences.setString(AppConstants.guestId, id);
  }

  @override
  Future<bool> clearGuestId() async {
    return await sharedPreferences.remove(AppConstants.guestId);
  }

  @override
  bool isGuestLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.guestId);
  }

  @override
  Future<void> saveUserNumberAndPassword(String number, String password, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.userPassword, password);
      await sharedPreferences.setString(AppConstants.userNumber, number);
      await sharedPreferences.setString(AppConstants.userCountryCode, countryCode);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.userPassword);
    await sharedPreferences.remove(AppConstants.userCountryCode);
    return await sharedPreferences.remove(AppConstants.userNumber);
  }

  @override
  String getUserCountryCode() {
    return sharedPreferences.getString(AppConstants.userCountryCode) ?? "";
  }

  @override
  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.userNumber) ?? "";
  }

  @override
  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.userPassword) ?? "";
  }

  @override
  String getGuestId() {
    return sharedPreferences.getString(AppConstants.guestId) ?? "";
  }

  @override
  Future<Response> loginWithSocialMedia(SocialLogInBodyModel socialLogInModel) async {
    return await apiClient.postData(AppConstants.socialLoginUri, socialLogInModel.toJson());
  }

  @override
  Future<Response> registerWithSocialMedia(SocialLogInBodyModel socialLogInModel) async {
    return await apiClient.postData(AppConstants.socialRegisterUri, socialLogInModel.toJson());
  }

  @override
  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  ///TODO: This methods need to remove from here.
  @override
  Future<bool> saveDmTipIndex(String index) async {
    return await sharedPreferences.setString(AppConstants.dmTipIndex, index);
  }
  ///TODO: This methods need to remove from here.
  @override
  String getDmTipIndex() {
    return sharedPreferences.getString(AppConstants.dmTipIndex) ?? "";
  }

  @override
  bool clearSharedData() {
    if(!GetPlatform.isWeb) {
      FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
      apiClient.postData(AppConstants.tokenUri, {"_method": "put", "cm_firebase_token": '@'});
    }
    sharedPreferences.remove(AppConstants.token);
    sharedPreferences.remove(AppConstants.guestId);
    sharedPreferences.setStringList(AppConstants.cartList, []);
    sharedPreferences.remove(AppConstants.userAddress);
    apiClient.token = null;
    apiClient.updateHeader(null, null, null,null, null);
    return true;
  }

  @override
  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.notification) ?? true;
  }

  @override
  void setNotificationActive(bool isActive) {
    if(isActive) {
      updateToken();
    }else {
      if(!GetPlatform.isWeb) {
        updateToken(notificationDeviceToken: '@');
        FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
        if(isLoggedIn()) {
          FirebaseMessaging.instance.unsubscribeFromTopic('zone_${AddressHelper.getAddressFromSharedPref()!.zoneId}_customer');
        }
      }
    }
    sharedPreferences.setBool(AppConstants.notification, isActive);
  }

  @override
  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  @override
  Future<bool> saveGuestContactNumber(String number) async {
    return await sharedPreferences.setString(AppConstants.guestNumber, number);
  }

  @override
  String getGuestContactNumber() {
    return sharedPreferences.getString(AppConstants.guestNumber) ?? "";
  }

  @override
  Future<Response> add(SignUpBodyModel signUpModel) async {
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