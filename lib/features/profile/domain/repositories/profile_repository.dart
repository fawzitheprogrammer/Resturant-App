import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/profile/domain/models/userinfo_model.dart';
import 'package:stackfood_multivendor/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';

class ProfileRepository implements ProfileRepositoryInterface {
  final ApiClient apiClient;
  ProfileRepository({required this.apiClient});

  @override
  Future<ResponseModel> updateProfile(UserInfoModel userInfoModel, XFile? data, String token) async {
    ResponseModel responseModel;
    Map<String, String> body = {};
    body.addAll(<String, String>{
      'f_name': userInfoModel.fName!, 'l_name': userInfoModel.lName!, 'email': userInfoModel.email!
    });
    Response response = await apiClient.postMultipartData(AppConstants.updateProfileUri, body, [MultipartBody('image', data)], [], handleError: false);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.bodyString);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<ResponseModel> changePassword(UserInfoModel userInfoModel) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.updateProfileUri, {'f_name': userInfoModel.fName, 'l_name': userInfoModel.lName,
      'email': userInfoModel.email, 'password': userInfoModel.password}, handleError: false);
    if (response.statusCode == 200) {
      String? message = response.body["message"];
      responseModel = ResponseModel(true, message);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<Response> delete(int? id) async {
    return await apiClient.postData(AppConstants.customerRemoveUri, {"_method": "delete"});
  }

  @override
  Future<UserInfoModel?> get(String? id) async {
    UserInfoModel? userInfoModel;
    Response response = await apiClient.getData(AppConstants.customerInfoUri);
    if (response.statusCode == 200) {
      userInfoModel = UserInfoModel.fromJson(response.body);
    }
    return userInfoModel;
  }

  @override
  Future getList({int? offset}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  
}