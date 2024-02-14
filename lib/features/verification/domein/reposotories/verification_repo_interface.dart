import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/interface/repository_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class VerificationRepoInterface<T> extends RepositoryInterface<T>{
  Future<ResponseModel> forgetPassword(String? phone);
  Future<ResponseModel> verifyToken(String? phone, String token);
  Future<ResponseModel> resetPassword(String? resetToken, String number, String password, String confirmPassword);
  Future<ResponseModel> checkEmail(String email);
  Future<Response> verifyEmail(String email, String token);
  Future<Response> verifyPhone(String? phone, String otp);
}