import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/verification/domein/services/verification_service_interface.dart';
import 'package:get/get.dart';

class VerificationController extends GetxController implements GetxService {
  final VerificationServiceInterface verificationServiceInterface;

  VerificationController({required this.verificationServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _verificationCode = '';
  String get verificationCode => _verificationCode;

  Future<ResponseModel> forgetPassword(String? phone) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await verificationServiceInterface.forgetPassword(phone);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyToken(String? phone) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await verificationServiceInterface.verifyToken(phone, _verificationCode);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> resetPassword(String? resetToken, String number, String password, String confirmPassword) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await verificationServiceInterface.resetPassword(resetToken, number, password, confirmPassword);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> checkEmail(String email) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await verificationServiceInterface.checkEmail(email);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyEmail(String email, String token) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await verificationServiceInterface.verifyEmail(email, token, _verificationCode);
    if(responseModel.isSuccess) {
      Get.find<ProfileController>().getUserInfo();
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyPhone(String? phone, String? token) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await verificationServiceInterface.verifyPhone(phone, token, _verificationCode);
    if(responseModel.isSuccess) {
      Get.find<ProfileController>().getUserInfo();
    }
    _isLoading = false;
    update();
    return responseModel;
  }


  void updateVerificationCode(String query, {bool canUpdate = true}) {
    _verificationCode = query;
    if(canUpdate){
      update();
    }
  }
}