import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/signup_body_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/social_log_in_body_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/reposotories/auth_repo_interface.dart';
import 'package:stackfood_multivendor/features/auth/domain/services/auth_service_interface.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService implements AuthServiceInterface{
  final AuthRepoInterface authRepoInterface;
  AuthService({required this.authRepoInterface});

  @override
  Future<ResponseModel> registration(SignUpBodyModel signUpModel, bool isCustomerVerificationOn) async {
    Response response = await authRepoInterface.registration(signUpModel);
    if(response.statusCode == 200){
      if(!isCustomerVerificationOn) {
        authRepoInterface.saveUserToken(response.body["token"]);
        await authRepoInterface.updateToken();
        authRepoInterface.clearGuestId();
      }
      return ResponseModel(true, response.body["token"]);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<ResponseModel> login({String? phone, String? password, bool customerVerification = false, bool alreadyInApp = false}) async {
    Response response = await authRepoInterface.login(phone: phone, password: password);
    if (response.statusCode == 200) {
      if(customerVerification && response.body['is_phone_verified'] == 0) {
      }else {
        authRepoInterface.saveUserToken(response.body['token'], alreadyInApp: alreadyInApp);
        await authRepoInterface.updateToken();
        await authRepoInterface.clearGuestId();
      }
      return ResponseModel(true, '${response.body['is_phone_verified']}${response.body['token']}');
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<ResponseModel> guestLogin() async {
    return await authRepoInterface.guestLogin();
  }

  @override
  void saveUserNumberAndPassword(String number, String password, String countryCode) {
    authRepoInterface.saveUserNumberAndPassword(number, password, countryCode);
  }

  @override
  Future<bool> clearUserNumberAndPassword() async {
    return authRepoInterface.clearUserNumberAndPassword();
  }

  @override
  String getUserCountryCode() {
    return authRepoInterface.getUserCountryCode();
  }

  @override
  String getUserNumber() {
    return authRepoInterface.getUserNumber();
  }

  @override
  String getUserPassword() {
    return authRepoInterface.getUserPassword();
  }

  @override
  Future<void> loginWithSocialMedia(SocialLogInBodyModel socialLogInModel, {bool isCustomerVerificationOn = false}) async {
    Response response = await authRepoInterface.loginWithSocialMedia(socialLogInModel);
    if (response.statusCode == 200) {
      String? token = response.body['token'];
      if(token != null && token.isNotEmpty) {
        if(isCustomerVerificationOn && response.body['is_phone_verified'] == 0) {
          Get.toNamed(RouteHelper.getVerificationRoute(response.body['phone'] ?? socialLogInModel.email, token, RouteHelper.signUp, ''));
        }else {
          authRepoInterface.saveUserToken(response.body['token']);
          await authRepoInterface.updateToken();
          authRepoInterface.clearGuestId();
          Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
        }
      }else {
        Get.toNamed(RouteHelper.getForgotPassRoute(true, socialLogInModel));
      }
    } else if(response.statusCode == 403 && response.body['errors'][0]['code'] == 'email'){
      Get.toNamed(RouteHelper.getForgotPassRoute(true, socialLogInModel));
    }
  }

  @override
  Future<void> registerWithSocialMedia(SocialLogInBodyModel socialLogInModel, {bool isCustomerVerificationOn = false}) async {
    Response response = await authRepoInterface.registerWithSocialMedia(socialLogInModel);
    if (response.statusCode == 200) {
      String? token = response.body['token'];
      if(isCustomerVerificationOn && response.body['is_phone_verified'] == 0) {
        Get.toNamed(RouteHelper.getVerificationRoute(socialLogInModel.phone, token, RouteHelper.signUp, ''));
      }else {
        authRepoInterface.saveUserToken(response.body['token']);
        await authRepoInterface.updateToken();
        authRepoInterface.clearGuestId();
        Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
      }
    }
  }

  @override
  Future<void> updateToken() async {
    await authRepoInterface.updateToken();
  }

  @override
  bool isLoggedIn() {
    return authRepoInterface.isLoggedIn();
  }

  @override
  String getGuestId() {
    return authRepoInterface.getGuestId();
  }

  @override
  bool isGuestLoggedIn() {
    return authRepoInterface.isGuestLoggedIn();
  }

  ///TODO: This function need to remove from here , as it is order part.
  @override
  void saveDmTipIndex(String i) {
    authRepoInterface.saveDmTipIndex(i);
  }
  ///TODO: This function need to remove from here , as it is order part.
  @override
  String getDmTipIndex() {
    return authRepoInterface.getDmTipIndex();
  }

  @override
  Future<void> socialLogout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.disconnect();
    await FacebookAuth.instance.logOut();
  }

  @override
  bool clearSharedData() {
    return authRepoInterface.clearSharedData();
  }

  @override
  bool setNotificationActive(bool isActive) {
    authRepoInterface.setNotificationActive(isActive);
    return isActive;
  }

  @override
  bool isNotificationActive() {
    return authRepoInterface.isNotificationActive();
  }

  @override
  String getUserToken() {
    return authRepoInterface.getUserToken();
  }

  @override
  Future<void> saveGuestNumber(String number) async {
     authRepoInterface.saveGuestContactNumber(number);
  }

  @override
  String getGuestNumber() {
    return authRepoInterface.getGuestContactNumber();
  }

}