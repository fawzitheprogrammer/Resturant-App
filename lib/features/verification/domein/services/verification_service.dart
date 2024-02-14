import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/reposotories/auth_repo_interface.dart';
import 'package:stackfood_multivendor/features/verification/domein/reposotories/verification_repo_interface.dart';
import 'package:stackfood_multivendor/features/verification/domein/services/verification_service_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class VerificationService implements VerificationServiceInterface {
  final VerificationRepoInterface verificationRepoInterface;
  final AuthRepoInterface authRepoInterface;

  VerificationService({required this.verificationRepoInterface, required this.authRepoInterface});

  @override
  Future<ResponseModel> forgetPassword(String? phone) async {
    return await verificationRepoInterface.forgetPassword(phone);
  }

  @override
  Future<ResponseModel> verifyToken(String? phone, String verificationCode) async {
    return await verificationRepoInterface.verifyToken(phone, verificationCode);
  }

  @override
  Future<ResponseModel> resetPassword(String? resetToken, String number, String password, String confirmPassword) async {
    return await verificationRepoInterface.resetPassword(resetToken, number, password, confirmPassword);
  }

  @override
  Future<ResponseModel> checkEmail(String email) async {
    return await verificationRepoInterface.checkEmail(email);
  }

  @override
  Future<ResponseModel> verifyEmail(String email, String token, String verificationCode) async {
    Response response = await verificationRepoInterface.verifyEmail(email, verificationCode);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepoInterface.saveUserToken(token);
      await authRepoInterface.updateToken();
      authRepoInterface.clearGuestId();
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<ResponseModel> verifyPhone(String? phone, String? token, String verificationCode) async {
    Response response = await verificationRepoInterface.verifyPhone(phone, verificationCode);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepoInterface.saveUserToken(token!);
      await authRepoInterface.updateToken();
      authRepoInterface.clearGuestId();
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

}