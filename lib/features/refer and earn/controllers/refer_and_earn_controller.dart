import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/profile/domain/models/userinfo_model.dart';
import 'package:get/get.dart';

class ReferAndEarnController extends GetxController implements GetxService {

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;

  Future<void> getUserInfo() async {
    if(Get.find<AuthController>().isLoggedIn() && Get.find<ProfileController>().userInfoModel == null) {
      await Get.find<ProfileController>().getUserInfo();
    }
    _userInfoModel = Get.find<ProfileController>().userInfoModel;
    update();
  }

}