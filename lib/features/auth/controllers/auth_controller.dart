import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/signup_body_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/social_log_in_body_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/services/auth_service_interface.dart';
import 'package:get/get.dart';

class AuthController extends GetxController implements GetxService {
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface}) {
    _notification = authServiceInterface.isNotificationActive();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _guestLoading = false;
  bool get guestLoading => _guestLoading;

  bool _acceptTerms = true;
  bool get acceptTerms => _acceptTerms;

  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  bool _notification = true;
  bool get notification => _notification;

  Future<ResponseModel> login(String? phone, String password, {bool alreadyInApp = false}) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await authServiceInterface.login(phone: phone, password: password,customerVerification: Get.find<SplashController>().configModel!.customerVerification!, alreadyInApp: alreadyInApp);
    if(responseModel.isSuccess) {
      Get.find<ProfileController>().getUserInfo();
      Get.find<CartController>().getCartDataOnline();
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> registration(SignUpBodyModel signUpModel) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await authServiceInterface.registration(signUpModel, Get.find<SplashController>().configModel!.customerVerification!);
    _isLoading = false;
    update();
    return responseModel;
  }

  void saveUserNumberAndPassword(String number, String password, String countryCode) {
    authServiceInterface.saveUserNumberAndPassword(number, password, countryCode);
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authServiceInterface.clearUserNumberAndPassword();
  }

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  String getUserCountryCode() {
    return authServiceInterface.getUserCountryCode();
  }

  String getUserNumber() {
    return authServiceInterface.getUserNumber();
  }

  String getUserPassword() {
    return authServiceInterface.getUserPassword();
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  Future<ResponseModel> guestLogin() async {
    _guestLoading = true;
    update();
    ResponseModel responseModel = await authServiceInterface.guestLogin();
    _guestLoading = false;
    update();
    return responseModel;
  }

  Future<void> loginWithSocialMedia(SocialLogInBodyModel socialLogInBody) async {
    _isLoading = true;
    update();
    await authServiceInterface.loginWithSocialMedia(socialLogInBody, isCustomerVerificationOn: Get.find<SplashController>().configModel!.customerVerification!);
    _isLoading = false;
    update();
  }

  Future<void> registerWithSocialMedia(SocialLogInBodyModel socialLogInModel) async {
    _isLoading = true;
    update();
    await authServiceInterface.registerWithSocialMedia(socialLogInModel, isCustomerVerificationOn: Get.find<SplashController>().configModel!.customerVerification!);
    _isLoading = false;
    update();
  }

  Future<void> updateToken() async {
    await authServiceInterface.updateToken();
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  String getGuestId() {
    return authServiceInterface.getGuestId();
  }

  bool isGuestLoggedIn() {
    return authServiceInterface.isGuestLoggedIn() && !authServiceInterface.isLoggedIn();
  }

  void saveDmTipIndex(String i){
    authServiceInterface.saveDmTipIndex(i);
  }

  String getDmTipIndex() {
    return authServiceInterface.getDmTipIndex();
  }

  Future<void> socialLogout() async {
    await authServiceInterface.socialLogout();
  }

  bool clearSharedData() {
    return authServiceInterface.clearSharedData();
  }

  bool setNotificationActive(bool isActive) {
    _notification = isActive;
    authServiceInterface.setNotificationActive(isActive);
    update();
    return _notification;
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

  Future<void> saveGuestNumber(String number) async {
    authServiceInterface.saveGuestNumber(number);
  }

  String getGuestNumber() {
    return authServiceInterface.getGuestNumber();
  }

}