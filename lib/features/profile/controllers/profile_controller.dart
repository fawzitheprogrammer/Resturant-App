import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/features/profile/domain/models/userinfo_model.dart';
import 'package:stackfood_multivendor/features/profile/domain/services/profile_service_interface.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileServiceInterface profileServiceInterface;

  ProfileController({required this.profileServiceInterface});

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;

  XFile? _pickedFile;
  XFile? get pickedFile => _pickedFile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getUserInfo() async {
    _pickedFile = null;
    _userInfoModel = await profileServiceInterface.getUserInfo();
    update();
  }

  void setForceFullyUserEmpty() {
    _userInfoModel = null;
    update();
  }


  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, String token) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await profileServiceInterface.updateProfile(updateUserModel, _pickedFile, token);
    if(responseModel.isSuccess){
      _userInfoModel = updateUserModel;
      _pickedFile = null;
      getUserInfo();
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  void updateUserWithNewData(User? user) {
    _userInfoModel!.userInfo = user;
  }

  Future<ResponseModel> changePassword(UserInfoModel updatedUserModel) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await profileServiceInterface.changePassword(updatedUserModel);
    _isLoading = false;
    update();
    return responseModel;
  }

  void pickImage() async {
    _pickedFile = await profileServiceInterface.pickImageFromGallery();
    update();
  }

  void initData() {
    _pickedFile = null;
  }

  Future removeUser() async {
    _isLoading = true;
    update();
    Response response = await profileServiceInterface.deleteUser();
    _isLoading = false;
    if (response.statusCode == 200) {
      showCustomSnackBar('your_account_remove_successfully'.tr);
      Get.find<AuthController>().clearSharedData();
      Get.find<CartController>().clearCartList();
      Get.find<FavouriteController>().removeFavourites();
      Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
    } else {
      Get.back();
    }
    update();
  }


}