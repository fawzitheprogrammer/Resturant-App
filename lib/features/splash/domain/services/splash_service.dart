import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/features/splash/domain/repositories/splash_repository_interface.dart';
import 'package:stackfood_multivendor/features/splash/domain/services/splash_service_interface.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';

class SplashService implements SplashServiceInterface {
  final SplashRepositoryInterface splashRepositoryInterface;
  SplashService({required this.splashRepositoryInterface});

  @override
  Future<Response> getConfigData() async {
    return await splashRepositoryInterface.getConfigData();
  }

  @override
  ConfigModel? prepareConfigData(Response response){
    ConfigModel? configModel;
    if(response.statusCode == 200) {
      configModel = ConfigModel.fromJson(response.body);
    }
    return configModel;
  }

  @override
  Future<bool> initSharedData() {
    return splashRepositoryInterface.initSharedData();
  }

  @override
  bool? showIntro() {
    return splashRepositoryInterface.showIntro();
  }

  @override
  void disableIntro() {
    return splashRepositoryInterface.disableIntro();
  }

  @override
  Future<void> saveCookiesData(bool data) async {
    return await splashRepositoryInterface.saveCookiesData(data);
  }

  @override
  bool getCookiesData() {
    return splashRepositoryInterface.getSavedCookiesData();
  }

  @override
  void cookiesStatusChange(String? data) {
    return splashRepositoryInterface.cookiesStatusChange(data);
  }

  @override
  bool getAcceptCookiesStatus(String data) {
    return splashRepositoryInterface.getAcceptCookiesStatus(data);
  }

  @override
  Future<bool> subscribeMail(String email) async{
    bool isSuccess = false;
    Response response = await splashRepositoryInterface.subscribeEmail(email);
    if (response.statusCode == 200) {
      showCustomSnackBar('subscribed_successfully'.tr, isError: false);
      isSuccess = true;
    }
    return isSuccess;
  }

  @override
  void toggleTheme(bool darkTheme) {
    splashRepositoryInterface.setThemeStatusSharedPref(darkTheme);
  }

  @override
  Future<bool> loadCurrentTheme() async {
    return await splashRepositoryInterface.getCurrentThemeSharedPref();
  }

}