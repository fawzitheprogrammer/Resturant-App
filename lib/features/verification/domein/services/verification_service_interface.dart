import 'package:stackfood_multivendor/common/models/response_model.dart';

abstract class VerificationServiceInterface{
  Future<ResponseModel> forgetPassword(String? phone);
  Future<ResponseModel> verifyToken(String? phone, String verificationCode);
  Future<ResponseModel> resetPassword(String? resetToken, String number, String password, String confirmPassword);
  Future<ResponseModel> checkEmail(String email);
  Future<ResponseModel> verifyEmail(String email, String token, String verificationCode);
  Future<ResponseModel> verifyPhone(String? phone, String? token, String verificationCode);
}